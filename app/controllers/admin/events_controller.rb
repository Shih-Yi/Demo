class Admin::EventsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_admin
  # before_action :authenticate

  layout "admin"

  def index
    @event = Event.all
  end

  protected

  def check_admin
    unless current_user.admin?
      raise ActiveRecord::RecordNotFound
      # redirect_to root_path # 最好不要出現警告 讓它自動忽略 不要讓人發現是後台
    end
  end

  # def authenticate
  #   authenticate_or_request_with_http_basic do |user_name, password|
  #     user_name == "username" && password == "password"
  #   end
  # end

end
