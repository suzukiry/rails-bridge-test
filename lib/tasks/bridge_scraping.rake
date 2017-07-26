require 'open-uri'
require 'nokogiri'

def trim(content)

  div_end_position = content.index("</div>")
  iframe_start_position = content.index("<iframe")
  new_content = content.slice(div_end_position+6..iframe_start_position-1)
  return new_content
end

def jpncal_to_ad(date)
  array = Array.new
  words = %w(年 月 日)
  regexp = Regexp.union(words)
  array = date.split(regexp)
  #words = %w(foo bar baz)
  #regexp = Regexp.new(words.join('|'))
  
  #year = array[0].to_i % 100
  year = array[0]
  month = array[1] 
  day = array[2]
  return [year,"%02d" % month, "%02d" % day].join('-')
end

namespace :scraping do

  desc "retrieve title"
    task :bridge_scrape => :environment do 
      #2017/07, 06, 05, 04, 03, 02
      URL = 'http://bridge-english.blogspot.jp/2017/01/'
      #URL = 'http://bridge-english.blogspot.jp/'
      doc = Nokogiri::HTML.parse(open(URL), nil, "UTF-8") 

      new_posts = doc.xpath('//div[@class="date-outer"]')

      new_posts.each do |daily_posts|

        # 1 post_date
        post_date = daily_posts.css('h2 span').inner_html
        post_date = jpncal_to_ad(post_date)
        p "post_date: (post_date})"
        
        posts = daily_posts.css('div.post-outer')
        posts.each do |new_post|

        # 2 eng_word, jpn_word
        p "eng_word, jpn_word: (#{new_post.css('h3').inner_text})"

        title = ""
        eng_word = ""
        jpn_word = ""
        post_type = 0

        title = new_post.css('h3').inner_text

        if /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/  =~ title then
          keywords = new_post.css('h3').inner_text.gsub(/[\u00A0\n]/, '').strip
          position = (keywords =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/)

          eng_word = keywords.slice(0,position)
          jpn_word = keywords.slice(position..-1)

          p "eng_word:#{eng_word}"
          p "jpn_word:#{jpn_word}"
        end
        
        # 3 youtube_url
        #p "Youtube_url: (#{new_post.xpath('//iframe').attribute('src').value})"
        #youtube_url = new_post.xpath('//iframe').attribute('src').value
        begin
          youtube_url = new_post.css('div iframe').attribute('src').value
          p "youtube_url: (#{youtube_url})"  
        rescue
          youtube_url = ''   # 例外時の処理
        end 
        
        # 4 site_url
        #p "site_url: (#{new_post.css('h3 a').attribute('href')})"
        site_url = new_post.css('h3 a').attribute('href').value
        p "site_url: (#{site_url})"  
          
        # 5 description
        begin
          description = trim(new_post.css('div.post-body.entry-content').inner_html.gsub(/[\u00A0\n]/, '').strip)
          p "description2:(#{description})"
        rescue
          description = new_post.css('div.post-body.entry-content').inner_html.gsub(/[\u00A0\n]/, '').strip
        end 
  
#        if eng_word.present? && jpn_word.present? then
#          post_type = 2
#        else if 
#          post_type = 0
#        end

        if /なんと言うか？/ =~ title then
          post_type = 1
        elsif /^\w.+(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])$/ =~ title then  
          post_type = 2
        elsif /^\w.+\w$/ =~ title then
          post_type = 3
        elsif /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/ =~ title then
          post_type = 4
        elsif /医学英語/ =~ title then
          post_type = 5
        elsif /ヒアリングの練習問題/ =~ title then
          post_type = 6
        elsif /私の英語ノート/ =~ title then
          post_type = 7
        else
          post_type = 8
        end
      
        p "POST_DATE (#{post_date})"
        
        new_entry = Entry.new
        #new_entry = Entry.find_or_initialize_by(title: title)

        if !Entry.exists?(title: title) then

        p "################# jpn_word does not exist #################"
          new_entry.post_type = post_type
          new_entry.title = title
          new_entry.eng_word = eng_word
          new_entry.jpn_word = jpn_word
          new_entry.description = description
          new_entry.youtube_url = youtube_url
          new_entry.site_url = site_url
          new_entry.post_date = post_date
          new_entry.save
        end 
        p "*****************************************"

      end
    end
  end
end