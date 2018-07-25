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
 
  def self.close_price(ticker_symbol)
    stockQuote = StockQuote::Stock.quote(ticker_symbol).close
  end
  
  def self.investment_value(user)
    total = UserStock.select("quantity * purchase_price as total1").where("user_id = #{user}").map(&:total1)
    totalInvest = total.sum
  end
   
  def self.day_change_total(user)
    stocks = Stock.joins(:user_stocks).select("Ticker as ticker, user_stocks.Quantity as quan").where("user_id = #{user}")
    stocks.to_a
    latestPriceTotal = 0
    quanCurrent = 0
    quanClose = 0
    closePriceTotal = 0
    
    stocks.each do |stock|
      latest_price = StockQuote::Stock.quote(stock.ticker).latest_price
      close_price = StockQuote::Stock.quote(stock.ticker).close
      quanCurrent = latest_price * stock.quan
      quanClose = close_price * stock.quan
      latestPriceTotal += quanCurrent     
      closePriceTotal += quanClose
    end
    dayGain = latestPriceTotal - closePriceTotal

  end
  
  def self.portfolio_value(user)
    stocks = Stock.joins(:user_stocks).select("Ticker as ticker, user_stocks.Quantity as quan").where("user_id = #{user}")
    stocks.to_a
    currentPriceTotal = 0
    quanCurrentPrice = 0
    
    stocks.each do |stock|
      currentPrice = StockQuote::Stock.quote(stock.ticker).latest_price
      quanCurrentPrice = currentPrice * stock.quan
      currentPriceTotal += quanCurrentPrice     
    end
    currentPriceTotal

  end
 
  
end