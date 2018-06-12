module Scraper
  class Thuan_Kieu_Scraper
    include Wombat::Crawler
    # base_url 'http://comtamthuankieu.com.vn/'
    # path 'products.html?page=1'

    dishes 'css=.listPro>li', :iterator do
      dish_name 'css=h4'
      price 'css=div.price'
      img_src xpath: './/img/@src'
    end
  end
end