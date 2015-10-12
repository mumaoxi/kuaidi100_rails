require "kuaidi100_rails/version"
require 'open-uri'
require 'net/http'
require 'json'

module Kuaidi100Rails
  API_URL = 'http://api.kuaidi100.com/api'

  class << self
    attr_accessor :API_KEY
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
