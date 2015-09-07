require 'quandl'
require 'date'

class BacktestsController < ApplicationController
  before_action :set_portfolio, only: [:calculate]

  def calculate

    holdings = @portfolio.holdings.all

    start_date = params[:backtest][:start_date]
    end_date = params[:backtest][:end_date]
    amount = params[:backtest][:starting_amount]

    Quandl.configure do |config|
      config.auth_token = 'nb1EsCSBc7fgbiRCLwYh'
    end
    data = Hash.new
    holdings.each do |holding|
      query = Quandl::Dataset.get(holding.security.identifier, {:format => :csv})
      query.headers(true)
      query.transform(:rdiff)
      query.start(start_date)
      query.end(end_date)
      data[holding.security.ticker] = {:data=>query.metadata, :weight=> holding.weight }
    end
    #logger.debug data
    perform_test(holdings, amount, data, start_date, end_date)

    render json: @portfolio, serializer: PortfolioSerializer
  end

  # could start at start_date - 1, because we would likely buy end of day the previous day.
  # or use both the opening and closing prices.
  def perform_test(holdings, amount, data, start_date, end_date)
    previous_date = Date.strptime(start_date,"%Y-%m-%d")
    folio_hist = Hash.new
    previous_date.upto(Date.strptime(end_date,"%Y-%m-%d")) do |date|
      if to_date_format(date) == start_date
        starting = Hash.new
        holdings.each do |holding|
          starting[holding.security.ticker] = holding.weight * amount
        end
        folio_hist[start_date] = starting
      end
      total = 0
      # sum total holdings
      holdings.each do |holding|
        sec_record = data[holding.security.ticker][:data].find { |point| point[:date]==to_date_format(date) }
        if sec_record == nil
          #logger.debug data[holding.security.ticker][:data].select {|point| point[:date]==to_date_format(date)}
          logger.debug "record is nil"
          folio_hist[to_date_format(date)] = folio_hist[to_date_format(previous_date)]
        else
          # logger.debug folio_hist[to_date_format(previous_date)][holding.security.ticker]
          logger.debug "getting performance impact"
          total = total + folio_hist[to_date_format(previous_date)][holding.security.ticker] \
          * (1 + sec_record[:adj_close])
        end
      end
      if folio_hist[to_date_format(date)] == nil
        amount = Hash.new
        holdings.each do |holding|
          amount[holding.security.ticker] = total * holding.weight
        end
        logger.debug amount
        folio_hist[to_date_format(date)] = amount
      end
      previous_date = date
    end
    logger.debug folio_hist
  end

  private
  def to_date_format(date)
    date.strftime("%Y-%m-%d")
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:backtest][:portfolio_id])
  end

  def backtest_params
    params.require(:backtest).permit(:portfolio_id, :start_date, :end_date, :starting_amount)
  end

end