class UsersController < ApplicationController

  before_action :require_user_logged_in, only: [:show]
  
  include UsersHelper
  TEST_NUM = 5
  
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

    # post_type = 2 : 翻訳テスト
    post_type = 2
    test = Test.new

    # 過去のテストに完了済みでないテストがある場合
    if current_user.tests.exists?(ended_at: nil)

      # ended_atがnil、かつ post_type=2のテストの存在確認
      current_user.tests.where(ended_at: nil).each do |existingtest|
        # post_type=2がある場合は該当未実施テストを実施
        if existingtest.show_entries.last.post_type == post_type then
          test = existingtest
        end
      end
      # 過去の完了済みでないテストに、post_type=2がない場合
      if test.id.blank?
        test = current_user.tests.build
      end
    # 過去のテストがすべて実施済みの場合
    else
      # 新規にtestを作成する
      test = current_user.tests.build
    end

    # テストの作成、テスト問題を作成
    if test.save then
      test.create_entry(TEST_NUM, post_type)
      test.update(test_date: Time.now)
      flash[:success] = 'テスト作成に成功'
    else
      flash.now[:danger] = 'テスト作成に失敗'
      render 'toppages/index'
    end

    # 親問題(ユーザが正答を問われるエントリ)を抽出
    @test_entries = test.show_entries.order("`tested_entries`.`id` asc")

    # 親問題の選択肢問題を抽出
    @test_entries.each do |test_entry|
      # 選択肢問題を抽出
      option_id_arrays << create_answer_array(test_entry.id, post_type)

    end
    @option_arrays = id_to_jpn_word(option_id_arrays)

  end
  
  def honyaku_result
    # TEST_NUM毎に必要
    answer_array = Array.new
    answer_array << params[:radio1]
    answer_array << params[:radio2]
    answer_array << params[:radio3]
    answer_array << params[:radio4]
    answer_array << params[:radio5]

    test = current_user.tests.last
    @test_id = test.id
    @test_entries = test.show_entries.order("`tested_entries`.`id` asc")

    # Compare and update score
    answer_array.zip(@test_entries).each do |answer, test_entry|

      test_entry_id = test_entry.id

      if answer.eql?(test_entry.jpn_word) then
        result = 1
      else
        result = 0
      end
      
      test.tested_entries.order('id').where(entry_id: test_entry_id).update(result: result)
    end
    test.update_attributes(score: test_score(@test_id), ended_at: Time.now)
    
    @tested_entries = test.tested_entries.order('id asc')

    # Ready variables for view
    test_entry_1 = @test_entries.to_a()[0]
    test_entry_2 = @test_entries.to_a()[1]
    test_entry_3 = @test_entries.to_a()[2]
    test_entry_4 = @test_entries.to_a()[3]
    test_entry_5 = @test_entries.to_a()[4]
  
    tested_entry_1 = @tested_entries.to_a()[0]
    tested_entry_2 = @tested_entries.to_a()[1] 
    tested_entry_3 = @tested_entries.to_a()[2]
    tested_entry_4 = @tested_entries.to_a()[3] 
    tested_entry_5 = @tested_entries.to_a()[4]

    @test_entry_1 = test_entry_1
    @test_entry_2 = test_entry_2
    @test_entry_3 = test_entry_3
    @test_entry_4 = test_entry_4
    @test_entry_5 = test_entry_5

    @tested_entry_1 = tested_entry_1
    @tested_entry_2 = tested_entry_2
    @tested_entry_3 = tested_entry_3
    @tested_entry_4 = tested_entry_4
    @tested_entry_5 = tested_entry_5
  
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # テストの選択肢用のArrayを作成  
  def create_answer_array(answer, post_type)

    random_answer_array = Array.new
    # 正解を先行して追加
    random_answer_array  << answer

    # テスト項目数だけ、選択肢用の回答を格納
    (1..2).each{|num|
      entry_number = Entry.where(post_type: post_type).pluck(:id).sample
    	while random_answer_array.include?(entry_number)
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
      jpn_word_arrays << [Entry.find(id1).jpn_word, Entry.find(id2).jpn_word, Entry.find(id3).jpn_word]
      p "jpn_word_arrays: #{jpn_word_arrays}"
    end
    return jpn_word_arrays
  end
end
