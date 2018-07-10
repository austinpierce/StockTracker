class AddFieldToUserStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :user_stocks, :quantity, :integer
    add_column :user_stocks, :purchase_price, :decimal
  end
end
