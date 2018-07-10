class UserStocksController < ApplicationController
  before_action :find_userStock, only: [:edit, :update]
  
  def create
    stock = Stock.find_by_ticker(params[:stock_ticker])
    if stock.blank?
      stock = Stock.new_from_lookup(params[:stock_ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:success] = "Stock #{@user_stock.stock.name} was successfully added to portfolio"
    redirect_to my_portfolio_path
  end
  
  def realPrice
    @realPrice = Stock.current_price(params[:stock_ticker])
  end
  
  def edit
    # set in before_action
  end
  
  def update
     # set in before_action
    if @user_stocks.update(userstocks_params)
      flash[:notice] = "Successfully updated"
      redirect_to my_portfolio_path
     else
      render 'edit'
    end
  end
  
  def destroy
    stock = Stock.find(params[:id])
    @user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    @user_stock.destroy
    flash[:notice] = "Stock was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end
  
  private
    
  def userstocks_params
    params.require(:user_stock).permit(:quantity, :purchase_price) #white listing
  end
  
  def find_userStock
    @user_stocks = UserStock.find(params[:id])
  end
  

  
  
end
