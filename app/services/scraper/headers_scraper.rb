require 'wombat'
module Scraper
  class HeadersScraper
    include Wombat::Crawler

=begin
  base_url "http://www.rubygems.org"
  path "/"
=end
    base_url "https://www.foody.vn/ho-chi-minh/trieu-phong-vo-van-tan/goi-mon"

    headers "^[^k]+$", :headers

    links do
      explode xpath: '//*[@id="deligroupdish-5990"]' do |e|
        p e
      end
    end
  end
end