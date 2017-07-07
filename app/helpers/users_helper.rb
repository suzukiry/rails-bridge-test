module UsersHelper
  def gravatar_url(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=identicon"
  end
  
  def test_score(test_id)
    # test_idに紐づいて結果を出さないとダメ。
    tested_entries = current_user.tests.where(id: test_id).first.tested_entries
    
    test_score = 0
    tested_entries.each do |tested_entry|
      if tested_entry.result.is_a?(TrueClass) then
        test_score += 1
      end
    end
    return test_score
  end

  def result_collection(test_id)

    passed_word_array = Array.new
    failed_word_array = Array.new
    result_collection = Array.new
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
end