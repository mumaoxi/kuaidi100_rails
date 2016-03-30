# encoding: utf-8
require "kuaidi100_rails/version"
require 'open-uri'
require 'net/http'
require 'json'
require 'faraday'

module Kuaidi100Rails
  API_URL = 'http://api.kuaidi100.com/api'
  SUBSCRIBE_URL = 'http://www.kuaidi100.com/poll'
  EXPRESS_KEYWORDS = {yuantong: '圆通',
                      shunfeng: '顺丰',
                      bjemstckj: '北京EMS',
                      ems: 'ems',
                      shentong: '申通',
                      yunda: '韵达',
                      zhongtong: '中通',
                      huitongkuaidi: '汇通',
                      debangwuliu: '德邦',
                      zhaijisong: '宅急送',
                      tiantian: '天天',
                      guotongkuaidi: '国通',
                      zengyisudi: '增益',
                      suer: '速尔',
                      ztky: '中铁物流',
                      zhongtiewuliu: '中铁快运',
                      ganzhongnengda: '能达',
                      youshuwuliu: '优速',
                      quanfengkuaidi: '全峰',
                      jd: '京东'}

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

  #cn_name to en_code
  def company_code(cn_name)
    EXPRESS_KEYWORDS.select { |k, v| cn_name.to_s.downcase.include?(v.to_s.downcase) }.keys[0].to_s
  end

  #en_code to cn_name
  def company_name(code_str)
    EXPRESS_KEYWORDS[code_str.to_s.to_sym]
  end

  #subscribe express
  #===Parameters==
  #+com+ company code
  #+nu+ express number
  #+from+ start from address
  #+to+ destination address
  #+salt+ random signature string
  #+mobiletelephone+ user phone
  #+seller+ seller's name
  #+commodity+ product's name
  def subscribe(com, nu, from, to, salt=nil, mobiletelephone=nil, seller=nil, commodity=nil)
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
              resultv2: '1',
              mobiletelephone: mobiletelephone,
              seller: seller,
              commodity: commodity
          }
      }
      p body

      response = Faraday.new(:url => SUBSCRIBE_URL).post do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        # req.params[:schema] = 'json'
        # req.params[:param] = body.to_json
        req.body={
            schema: 'json',
            param: body.to_json
        }
      end

      hash = SHash.new(JSON.parse(response.body))
      p hash
      return hash[:returnCode].to_i
    rescue Exception => e
      puts "error #{e}"
    end
    0
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
