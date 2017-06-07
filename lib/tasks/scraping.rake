require 'open-uri'
require 'nokogiri'

namespace :scraping do

  desc "retrieve title"
  task :find => :environment do
    URL = 'http://bridge-english.blogspot.jp/'

    doc = Nokogiri::HTML.parse(open(URL), nil, "UTF-8")
    doc.xpath('//*[@id="Blog1"]/div[1]/div[1]/div/div[1]/div/h3').each do |node|
      puts node.inner_text
    end
  end
end