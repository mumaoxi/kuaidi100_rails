require 'kuaidi100_rails'
require 'kuaidi100_rails'
describe Kuaidi100Rails do

  it 'crawl' do
    Kuaidi100Rails.crawl('yuantong', 'd00037098973')
    p Kuaidi100Rails::SHash.new({'a' => 0, 'b' => ['0', 1, 2], 'c' => [{'a' => ['12', 4, {'a' => 'b', 'saxer' => [1, 2, 3, 6]}]}]})
  end

  it 'subscribe' do

    Kuaidi100Rails.subscribe('yuantong', 'd00025359556', '北京市', '湖北省十堰市丹江口市')
  end
end