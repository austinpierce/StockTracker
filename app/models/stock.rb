class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  
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
  
    
  def self.current_price(ticker_symbol)
    stockQuote = StockQuote::Stock.quote(ticker_symbol).latest_price
  end
 
  def self.open_price(ticker_symbol)
    stockQuote = StockQuote::Stock.quote(ticker_symbol).open
  end
  
  def self.investment_value(user)
    total = UserStock.select("quantity * purchase_price as total1").where("user_id = #{user}").map(&:total1)
    totalInvest = total.sum
  end
  
  def self.return_all_stocks
    x = Stock.joins(:user_stocks).select("stocks.id, Name, Ticker, user_stocks.Quantity as   quan, user_stocks.purchase_price as pp4, user_stocks.id as usid")
    x.to_a
  end
  
  def self.day_change_total#(user)
    stocks = Stock.joins(:user_stocks).select("Ticker as ticker").where("user_id = 1").map(&:ticker)
    latestPriceTotal = 0
    openPriceTotal = 0
    
    stocks.each do |stock|
      latest_price = StockQuote::Stock.quote(stock).latest_price
      open_price = StockQuote::Stock.quote(stock).open
      latestPriceTotal += latest_price     
      openPriceTotal += open_price
    end
    
    grandtotal = latestPriceTotal - openPriceTotal
    puts grandtotal
  end
  
end