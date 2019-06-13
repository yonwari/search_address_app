require "csv"
require "nkf"

def search_address
  puts ""
  puts "住所検索したい文字列を入力してください"

  # 検索ワード取得と空白削除
  search_word = gets.to_s
  search_word = search_word.gsub(/(\s|　)+/, '')

  # 入力制御系
  if search_word.include?(",")
    puts "半角カンマは入力しないでください"
    return
  elsif search_word.length < 2
    puts "検索は2文字以上で行ってください"
    return
  end

  puts "住所検索を開始します"
  puts ""
  puts "~検索中~"
  puts ""

  # 検索ワードを2文字ずつに分割
  # それぞれでインデックスファイルを検索し、該当する行番号の積集合に該当するレコードを取得する
  search_bigram = search_word.each_char.each_cons(2).map{|chars| chars.join}

  # 分割後の検索ワード個数カウント用変数
  bigram_num = 0
  # 検索ワードにマッチするソースファイルの行番号を格納する二次元配列
  match_list = Array.new(search_bigram.length).map{Array.new()}

  # インデックスファイルから検索ワードを含むソースファイルの行番号を取得
  search_bigram.each do |str|
    CSV.foreach("index_file.csv") do |row|
      if row[0].include?(str)
        match_list[bigram_num] << row[1]
      end
    end
    bigram_num += 1
  end

  # 分割された検索ワード全てを含むものに絞り込み
  total_list = match_list[0]
  match_list.each do |list|
    total_list = total_list & list
  end

  result = []
  # 行番号をもとにソースファイルから結果取得
  File.open("clear_source.csv", "r") do |file|
    all_record = file.readlines
    if total_list
      total_list.each do |line_num|
        result << all_record[line_num.to_i - 1]
      end
    end
  end

  puts "<<検索結果>>"
  result.each do |list|
    puts list
  end
  puts "・・・検索結果は#{total_list.length}件です"
end