class Dashboard::Admin::AdminController < ApplicationController
  before_action :authenticate_manager!
  layout 'admin'
end
