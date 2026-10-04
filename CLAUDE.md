# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A minimal Rails 8 demo app showing off the "Solid" stack (`solid_queue`, `solid_cache`, `solid_cable`) as database-backed replacements for Redis. The one real feature is a `Customer` CRUD/index page with a background CSV export job emailed to a user, used to demonstrate immediate and delayed (`wait_until`) job scheduling via Solid Queue.

## Commands

```bash
bin/setup              # bundle install + db:prepare + clears logs/tmp (skip with --skip-server to avoid booting the server)
bin/rails server        # or `bin/dev` (same thing)
bin/jobs                 # runs the Solid Queue worker/dispatcher (SolidQueue::Cli) — required for jobs to actually process
bin/rails db:seed       # seeds 200,000 fake Customer rows via Faker (slow)
bin/rails test                                  # full test suite
bin/rails test test/jobs/export_customers_csv_job_test.rb   # single file
bin/rails test test/jobs/export_customers_csv_job_test.rb -n test_name  # single test
bin/rubocop                                      # lint (rails-omakase style, NewCops: enable)
bin/brakeman                                     # static security scan
```

Three separate SQLite databases are configured per environment (`storage/*.sqlite3` in dev/prod): `primary`, `queue` (Solid Queue), and in production also `cache` and `cable`. Each has its own migration path (`db/queue_migrate`, `db/cache_migrate`, `db/cable_migrate`) separate from the main `db/migrate`. Use `bin/rails db:prepare` to set up all of them together.

## Architecture

- **Jobs run out-of-process**: `bin/jobs` must be running (alongside the web server) for `ExportCustomersCsvJob` to actually execute — enqueuing via `perform_later` in the web process does nothing by itself. Worker/dispatcher polling and concurrency are configured per-environment in `config/queue.yml`.
- **Recurring jobs**: `config/recurring.yml` defines scheduled/cron-style jobs picked up by the Solid Queue scheduler (currently only wired for `development`: `ExportCustomersCsvJob` runs every minute against `admin@gmail.com`).
- **CustomersController#export_csv** (`app/controllers/customers_controller.rb`) is the reference implementation for enqueueing: if `export_time` param is present it uses `.set(wait_until:)` to delay the job, otherwise it enqueues immediately — this is the pattern to follow for any new delayed-job UI.
- **ExportCustomersCsvJob** builds a CSV to `tmp/`, emails it via `CustomerMailer#send_csv` synchronously (`deliver_now`, since we're already in a background job), then deletes the temp file.
- **Mounted engines**: `/jobs` is `MissionControl::Jobs::Engine` (web UI for inspecting/retrying Solid Queue jobs), `/letter_opener` is `LetterOpenerWeb::Engine` (view sent emails in development instead of actually sending).
- **`app/controllers/test_customers_controller.rb` is intentionally bad code** — it defines a second `CustomersController` class full of deliberate Rubocop violations (class/global vars, `ExportNow` method naming, performance anti-patterns, deeply nested conditionals). It exists solely as a fixture to exercise the reviewdog/Rubocop CI check (`.github/workflows/ci.yml`) on PRs and is not routed or otherwise used — don't "fix" it as if it were real application code, and don't take it as a model for style.
- **CI**: `.github/workflows/ci.yml` runs `rubocop` via `reviewdog/action-rubocop` on every PR (`only_changed: true`, posts inline review comments). There is no automated test-running CI job currently — run `bin/rails test` locally before committing.
