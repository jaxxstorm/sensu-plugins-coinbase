#!/usr/bin/env ruby
#
require 'coinbase/exchange'
require 'sensu-plugin/check/cli'
require 'pp'

class CheckCoinbasePrice < Sensu::Plugin::Check::CLI

  option :api_key,
    short:        '-k API_KEY',
    long:         '--api-key API_KEY',
    description:  'gdax API key',
    required:     true

  option :api_secret,
    short:        '-s API_SECRET',
    long:         '--api-secret API_SECRET',
    description:  'gdax API secret',
    required:     true

  option :api_pass,
    short:       '-p API_PASS',
    long:        '--api-pass API_PASS',
    description: 'gdax API pass',
    required:    true

  option :product,
    short:       '-P PRODUCT',
    long:        '--product PRODUCT',
    description: 'gdax product',
    default:     'BTC-GBP'

  option :low_price,
    short:       '-l LOW_PRICE',
    long:        '--low-price LOW_PRICE',
    description: 'The value we should alert on if the price drops below',
    proc:        proc(&:to_i),
    required:    true

  option :high_price,
    short:       '-h HIGH_PRICE',
    long:        '--high-price HIGH_PRICE',
    description: 'The value we should alert on if the price goes above',
    proc:        proc(&:to_i),
    required:    true

    

   def run

    rest_api = Coinbase::Exchange::Client.new(config[:api_key], config[:api_secret], config[:api_pass])
    response = rest_api.last_trade(product_id: config[:product])

    case config[:product]
    when "BTC-GBP"
      currency = "£"
      coin     = "bitcoin"
    when "BTC-USD"
      currency = "$"
      coin     = "bitcoin"
    when "BTC-EUR"
      currency = "€"
      coin     = "bitcoin"
    when "ETH-GBP"
      currency = "£"
      coin     = "ethereum"
    when "ETH-USD"
      currency = "$"
      coin     = "ethereum"
    when "ETH-EUR"
      currency = "€"
      coin     = "ethereum"
    end

    if response.bid > config[:low_price] && response.bid < config[:high_price]
      ok "Current #{coin} price is #{currency}%.2f" % response.price
    else
      critical "Current #{coin} price is #{currency}%.2f" % response.price
    end


   end

end



