class GiveDefaultValueForUserStocks < ActiveRecord::Migration[5.1]
  def change
    change_column :user_stocks, :quantity, :integer, default: 0
    change_column :user_stocks, :purchase_price, :decimal, default: 0    
  end
end
