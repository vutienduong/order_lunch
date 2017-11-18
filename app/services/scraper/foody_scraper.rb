module Scraper
  class FoodyScraper
    include Wombat::Crawler
    # base_url 'https://www.foody.vn'
    # path '/ho-chi-minh/trieu-phong-vo-van-tan/goi-mon'

    some_data css: 'div.deli-box-menu-detail'
    another_info xpath: '//*[@id="deligroupdish-69829"]'
    coupon 'css=.coupons'
    thumb xpath: '//*[@id="deligroupdish-69829"]/div[1]/div[1]/a/img/@src'

    dishes 'css=.deli-dish>div.deli-box-menu-detail.clearfix', :iterator do
      dish_name 'css=h3'
      dish_desc 'css=.deli-desc'
      price 'css=.txt-blue.font16.bold'
      #img_url 'css=.inline.cboxElement>img'
      img_src xpath: './/img/@src'
    end
  end
end