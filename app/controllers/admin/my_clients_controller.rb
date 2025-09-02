# frozen_string_literal: true

class Admin::MyClientsController < ApplicationController
  layout "admin/application"

  def index
    @my_clients = MyClient.all
  end

  def new
    @my_client = MyClient.new
    render layout: "application"
  end
end
