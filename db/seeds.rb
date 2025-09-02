# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# 200000.times do
#   Customer.create(
#     name: Faker::Name.name,
#     email: Faker::Internet.unique.email,
#     country: Faker::Address.country,
#     phone: Faker::PhoneNumber.phone_number,
#     age: Faker::Number.between(from: 18, to: 30)
#   )
# end
# puts "200,000 customers have been created."

# 3.times do
#   Client.create(
#     name: Faker::Name.name,
#     email: Faker::Internet.unique.email,
#     country: Faker::Address.country,
#     phone: Faker::PhoneNumber.phone_number,
#     age: Faker::Number.between(from: 18, to: 30)
#   )
# end
# puts "3 clients have been created."

3.times do
  MyClient.create(
    uuid: SecureRandom.uuid,
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    country: Faker::Address.country,
    phone: Faker::PhoneNumber.phone_number,
    age: Faker::Number.between(from: 18, to: 30)
  )
end
puts "3 clients have been created."
