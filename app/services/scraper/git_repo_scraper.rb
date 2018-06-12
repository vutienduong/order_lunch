require 'wombat'
module Scraper
  class GitRepoScraper
    include Wombat::Crawler

    base_url "http://www.github.com"
    path "/explore"

    wrap_repositories "css=div.mb6"
    repositories "css=div.mb6[1]>article", :iterator do
      repo 'css=h3'
      description 'css=p.description'
    end
    repo_xpath xpath: '/html/body/div[4]/div[2]/div[1]/div[4]'
  end
end