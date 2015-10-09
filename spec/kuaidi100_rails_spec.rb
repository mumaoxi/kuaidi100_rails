require 'kuaidi100_rails'
require 'kuaidi100_rails'
describe Kuaidi100Rails do

  it 'crawl' do
    Kuaidi100Rails.API_KEY='121312312'
    Kuaidi100Rails.crawl('yuantong', '')


    p Kuaidi100Rails::SHash.new({'a' => 0, 'b' => ['0', 1, 2], 'c' => [{'a' => ['12', 4, {'a'=> 'b','saxer'=>[1,2,3,6]}]}]})
  end
end