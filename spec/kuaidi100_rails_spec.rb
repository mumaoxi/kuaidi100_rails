require 'kuaidi100_rails'
require 'kuaidi100_rails'
describe Kuaidi100Rails do

  it 'crawl' do
    Kuaidi100Rails.API_KEY='123456'
    Kuaidi100Rails.crawl('yuantong', 'd00037098973')
    p Kuaidi100Rails::SHash.new({'a' => 0, 'b' => ['0', 1, 2], 'c' => [{'a' => ['12', 4, {'a' => 'b', 'saxer' => [1, 2, 3, 6]}]}]})
  end

  it 'subscribe' do
    Kuaidi100Rails.POLL_CALLBACK_URL='http://test.api.yepcolor.com/v2/kuaidis/callback'
    Kuaidi100Rails.POLL_KEY = '123456'
    # Kuaidi100Rails.subscribe('yuantong', 'd00025359570', '北京市', '江苏省镇江市丹阳市')
  end

  it 'company_to_code' do
    p Kuaidi100Rails.company_code('德邦')
    p Kuaidi100Rails.company_code('EMS')
    p Kuaidi100Rails.company_code('北京EMS')
    p Kuaidi100Rails.company_code('圆通')
    p Kuaidi100Rails.company_code('申通')
    p Kuaidi100Rails.company_code('韵达')
    p Kuaidi100Rails.company_code('顺丰')
  end

  it 'company name' do
    p Kuaidi100Rails.company_name('shentong')
    p Kuaidi100Rails.company_name('ems')
    p Kuaidi100Rails.company_name('yuantong')
    p Kuaidi100Rails.company_name(:jd)
  end
end