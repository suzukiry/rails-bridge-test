module UsersHelper
  def gravatar_url(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
  end
  
  # Test IDのテスト合計点を取得
  def test_score(test_id)
    tested_entries = current_user.tests.where(id: test_id).first.tested_entries
    
    test_score = 0
    tested_entries.each do |tested_entry|
      if tested_entry.result.is_a?(TrueClass) then
        test_score += 1
      end
    end
    return test_score
  end

  # Test IDからテスト実施日を取得
  def test_date(test_id)
    return current_user.tests.find(test_id).test_date.in_time_zone('Tokyo').strftime('%Y/%m/%d %H:%M')
  end
  
  # Test IDから正解・不正解の単語情報を取得
  def result_collection(test_id)

    result_collection = Array.new
    passed_word_array = Array.new
    failed_word_array = Array.new

    test = current_user.tests.find(test_id)
    tested_entries = test.tested_entries.order("id asc")
    test_entries = test.show_entries.order("`tested_entries`.`id` asc")
    
    tested_entries.zip(test_entries).each do |tested_entry, test_entry|

      if tested_entry.result.is_a?(TrueClass) then
        passed_word_array << [test_entry.eng_word, test_entry.site_url]
      else
        failed_word_array << [test_entry.eng_word, test_entry.site_url]
      end
    end
    result_collection << passed_word_array << failed_word_array
    return result_collection
  end

  def result_dategroup(tests)
    dategroup_array = []
    
    con = ActiveRecord::Base.connection
    date_array = con.select_values("select DATE_FORMAT(convert_tz(test_date,'UTC','Asia/Tokyo'), '%Y-%m-%d') from tests where user_id =1 group by DATE_FORMAT(convert_tz(test_date,'UTC','Asia/Tokyo'), '%Y%m%d')")
    date_array.reverse!
    p "date_array: #{date_array}"

    date_array.each do |date|
      from = Date.parse(date) - 9.hours
      to = from + 1.day
      p "from: #{from} to #{to}"
      dategroup_array << [date,tests.where(test_date: from...to)] # .order(test_date: :desc)がいるかいらないかわからない。
    end

    p "dategroup_array: #{dategroup_array}"
    return dategroup_array
  end
end