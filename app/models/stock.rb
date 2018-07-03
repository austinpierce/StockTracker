class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  
  def current_price(ticker_symbol)
    @currentPrice = StockQuote:Stock.quote(ticker_symbol).latest_price  
  end
  
  def self.new_from_lookup(ticker_symbol)
    begin
      looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
      new(name: looked_up_stock.company_name, ticker: looked_up_stock.symbol, last_price: looked_up_stock.latest_price)
    rescue Exception => e
      return nil
    end
  end
  
  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
  
end