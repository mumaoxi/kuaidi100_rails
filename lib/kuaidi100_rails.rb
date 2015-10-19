require "kuaidi100_rails/version"
require 'open-uri'
require 'net/http'
require 'json'
require 'faraday'

module Kuaidi100Rails
  API_URL = 'http://api.kuaidi100.com/api'
  SUBSCRIBE_URL = 'http://www.kuaidi100.com/poll'

  class << self
    attr_accessor :API_KEY
    attr_accessor :POLL_KEY
    attr_accessor :POLL_CALLBACK_URL
  end

  module_function

  def crawl(com, nu)
    begin
      url = URI.parse(API_URL)
      params = {:id => Kuaidi100Rails.API_KEY, :com => com, :nu => nu, :show => 0, :muti => 1, :order => 'desc'}
      url.query = URI.encode_www_form(params)
      p url
      res = Net::HTTP.get(url)
      hash = SHash.new(JSON.parse(res))
      p hash
    rescue Exception => e
      puts "error #{e}"
    end
  end

  #subscribe express
  #===Parameters==
  #+com+ company code
  #+nu+ express number
  #+from+ start from address
  #+to+ destination address
  #+salt+ random signature string
  def subscribe(com, nu, from, to, salt=nil)
    begin
      body = {
          company: com,
          number: nu,
          from: from,
          to: to,
          key: Kuaidi100Rails.POLL_KEY,
          parameters: {
              callbackurl: Kuaidi100Rails.POLL_CALLBACK_URL,
              salt: salt,
              resultv2: '1'
          }
      }
      p body

      response = Faraday.new(:url => SUBSCRIBE_URL).post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.params[:schema] = 'json'
        req.params[:param] = body.to_json
      end

      hash = SHash.new(JSON.parse(response.body))
      p hash

    rescue Exception => e
      puts "error #{e}"
    end
  end

  class SHash < Hash

    def initialize(json_object=nil)
      json_object && json_object.inject(self) { |memo, (key, v)|
        if v.instance_of?(Hash)
          memo[key.to_sym]= SHash.new(v)
        elsif v.instance_of?(Array)

          s_array = ->(value) {
            value.inject([]) { |m, i|
              if i.instance_of?(Hash)
                m<< SHash.new(i)
              elsif i.instance_of?(Array)
                m<< s_array.call(i)
              else
                m<<i
              end
              m
            }
          }
          memo[key.to_sym] = s_array.call(v)
        else
          memo[key.to_sym]=v
        end
        memo
      }
    end
  end

end
