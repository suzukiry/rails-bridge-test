require 'open-uri'
require 'nokogiri'

namespace :scraping do

  desc "retrieve title"
    task :test => :environment do 
      URL = 'http://bridge-english.blogspot.jp/' 
      doc = Nokogiri::HTML.parse(open(URL), nil, "UTF-8") 

      posts = doc.xpath('//div[@class="post hentry uncustomized-post-template"]')
      posts.each do |post|

#       1つ目　OK
#       p post.xpath('//h3').inner_text Check later はダメ。Check later
        p post.css('h3').inner_text

#       2つ目　OK
        p post.xpath('//div[@class="post-body entry-content"]').inner_html

#       3つ目　OK xpathでできたが、CSSでできなかった。
#       どうしてもiframeのsrc属性が取れないです。 試行錯誤中。
#       下記でタグ情報までは取得できる。
        #p post.css('iframe').class
        #p post.css('iframe')
        
        #p post.css('iframe')[0].class
        #p post.css('iframe')[0].to_html
        
        #p post.xpath('//iframe').to_html
        p post.xpath('//iframe').attribute('src').value
        
#       下記はテスト中。
#        p post.css('iframe').attribute('src').value
#        puts post.css('iframe').attr("src",value)
#         element = post.css('iframe[src]')
#         puts element         
#         puts element.class         
#
#        puts post.css('iframe')[0][:src]
#         puts post.at('iframe')['src']
#        puts post.css('iframe')[0].attr('src')
    
      end
  end
end