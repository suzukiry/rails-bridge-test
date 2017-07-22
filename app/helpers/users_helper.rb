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
  
  #各日付ごとのテスト結果を返却
  #ex) [["2017-07-31 UTC XX:XX:XX",tests object],["2017-07-30 UTC XX:XX:XX", tests object],,,]
  def result_dategroup(user_id, tests)
    dategroup_array = []
    
    con = ActiveRecord::Base.connection
    date_array = con.select_values("select DATE_FORMAT(convert_tz(test_date,'UTC','Asia/Tokyo'), '%Y-%m-%d') from tests where user_id ="+user_id.to_s+" GROUP BY DATE_FORMAT(convert_tz(test_date,'UTC','Asia/Tokyo'), '%Y%m%d')")
    date_array.reverse!

    date_array.each do |date|
      from = Date.parse(date) - 9.hours
      to = from + 1.day
      p "from: #{from} to #{to}"
  
      dategroup_array << [date,tests.where(test_date: from...to).to_a] # .order(test_date: :desc)がいるかいらないかわからない。
      #dategroup_array << [date,tests.where(test_date: from...to)] # .order(test_date: :desc)がいるかいらないかわからない。
      p "dategroup_array: #{dategroup_array}"
      
    end

    # 未実施テストが存在する場合は表示しない。
    if dategroup_array.nil? then
      dategroup_array[0][1].shift if dategroup_array[0][1][0].ended_at.blank?
    end

    p "dategroup_array: #{dategroup_array}"
    return dategroup_array
  end
  
  #post_typeの現在の総件数を求める
  def check_entry_num(post_type)
    return Entry.where(post_type: post_type).count
  end
  
  #userの習熟している単語数を求める（正解数 / テスト実施回数 >= 80%）
  def check_mastered_entry_num(user_id)
    con = ActiveRecord::Base.connection
    mastered_entry_array = con.select_values("select entry_id from tested_entries where test_id IN (select id from tests where user_id = "+user_id.to_s+") GROUP BY entry_id having SUM(CAST(result AS SIGNED INTEGER))/COUNT(entry_id) >= 0.8")
#    mastered_entry_array = con.select_values("select entry_id from tested_entries where test_id IN (select id from tests where user_id = "+user_id.to_s+") GROUP BY entry_id having SUM(result)/COUNT(entry_id) >= 0.8")
    p "check_mastered_entry_num: #{mastered_entry_array}/#{mastered_entry_array.count}"
    return mastered_entry_array.count

  end
end