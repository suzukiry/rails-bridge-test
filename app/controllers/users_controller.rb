class UsersController < ApplicationController

  before_action :require_user_logged_in, only: [:show]
  
  include UsersHelper
  
  TEST_NUM = 2
  
  def show
    @user = User.find(params[:id])
    @tests = @user.tests.order("test_date desc")
    
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end

  end

  # 翻訳テスト
  def honyaku
    option_id_arrays = Array.new
    #entry_count = Entry.count
    # post_type = 2 : 翻訳テスト
    post_type = 2
    test = current_user.tests.build

    if test.save
      flash[:success] = 'テスト作成に成功'
#      test.populate(create_entry_array(TEST_NUM,entry_count))
      test.create_entry(TEST_NUM, post_type)
      test.update(test_date: Time.now)
    else
      #@microposts = current_user.feed_microposts.order('created_at DESC').page(params[:page])
      #flash.now[:danger] = 'テスト作成に失敗'
      #render 'toppages/index'
    end

    @test_entries = test.show_entries.order("`tested_entries`.`id` asc")
    @test_entries.each do |test_entry|

#      option_id_arrays << create_option_array(test_entry.id, entry_count)
       option_id_arrays << create_answer_array(TEST_NUM, test_entry.id, post_type)
    end
    @option_arrays = id_to_jpn_word(option_id_arrays)
  end
  
  def honyaku_result
    answer_array = Array.new
    answer_array << params[:radio1]
    answer_array << params[:radio2]
    
    test = current_user.tests.last
    @test_id = test.id
    @test_entries = test.show_entries.order("`tested_entries`.`id` asc")
    @tested_entries = test.tested_entries
    
    # Compare and update score
    answer_array.zip(@test_entries).each do |answer, test_entry|
      test_entry_id = test_entry.id
      if answer.eql?(test_entry.jpn_word) then
        result = 1
      else
        result = 0
      end
      @tested_entries.where(entry_id: test_entry_id).update(result: result)
    end
    test.update_attributes(score: test_score(@test_id), ended_at: Time.now)
    
    # Ready variables for view
    test_entry_1 = @test_entries.first
    test_entry_2 = @test_entries.second #ほかのユーザが混ざるとこれだとダメ。配列に移さないと。。

    tested_entry_1 = @tested_entries.first
    tested_entry_2 = @tested_entries.first.next #ほかのユーザが混ざるとこれだとダメ。配列に移さないと。。

    @test_entry_1 = test_entry_1
    @test_entry_2 = test_entry_2
    @tested_entry_1 = tested_entry_1
    @tested_entry_2 = tested_entry_2
  
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

=begin 
  # テスト用のエントリーのIDをランダムに作成 
  def create_entry_array(test_num, max_entry_num)
    random_entry_array = Array.new
    random = Random.new
  
    (1..test_num).each{|num|
    	begin 
    		entry_number = random.rand(1..max_entry_num)
    	end while random_entry_array.include?(entry_number)
    	random_entry_array << entry_number
    }
    return random_entry_array
  end

  # テスト用のエントリーのIDをランダムに作成 
  

  def create_random_id_array(test_num, post_type)
    random_random_id_array = Array.new
    random = Random.new
  
    (1..test_num).each{|num|
    	begin 
    		entry_number = random.rand(1..max_entry_num)
    	end while random_entry_array.include?(entry_number)
    	random_entry_array << entry_number
    }
    return random_entry_array
  end
=end

  # テストの選択肢用のArrayを作成  
  def create_answer_array(test_num, answer, post_type)

    random_answer_array = Array.new
    #random = Random.new
    random_answer_array  << answer
  
    (1..test_num).each{|num|
    #	entry_number = random.rand(1..max_entry_num)
      entry_number = Entry.where(post_type: post_type).pluck(:id).sample
    	while random_answer_array.include?(entry_number)
        #entry_number = random.rand(1..max_entry_num)
        entry_number = Entry.where(post_type: post_type).pluck(:id).sample
    	end
    	random_answer_array << entry_number
    }
    random_answer_array.shuffle!
    return random_answer_array
  end

  # テストの選択肢用のArrayを作成  
  def create_option_array(answer, max_entry_num)
    random_option_array = Array.new
    random = Random.new
    random_option_array  << answer
  
    (1..2).each{|num|
    	entry_number = random.rand(1..max_entry_num)
    	while random_option_array.include?(entry_number)
        entry_number = random.rand(1..max_entry_num)
    	end
    	random_option_array << entry_number
    }
    random_option_array.shuffle!
    return random_option_array
  end
  
  # Array内のidをもとに、jpn_wordへ変換
  def id_to_jpn_word(id_arrays)
    jpn_word_arrays = Array.new

    id_arrays.each do  |id1, id2, id3|
         jpn_word_arrays << [Entry.where(id: id1).first.jpn_word,Entry.where(id: id2).first.jpn_word,Entry.where(id: id3).first.jpn_word,]
    end
    return jpn_word_arrays
  end

end
