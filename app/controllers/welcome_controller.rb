class WelcomeController < ApplicationController
  
  def index
    @user = current_user
    @user_stocks = current_user.user_stocks
  end
  
end