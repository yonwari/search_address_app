require "csv"
require "nkf"

def make_index
  # ソースファイルを整える
  File.open("clear_source.csv", "w") do |file|
    CSV.foreach("KEN_ALL.CSV", encoding: "Shift_JIS:UTF-8") do |row|
      array = [row[2], row[6], row[7], row[8]]
      info = array.join(",")
      file.puts info
    end
  end

  # ソースファイルを１行ずつ読み込み、2文字ずつ分割して出力
  tmp_file = []
  line_num = 1 #読み込んでいるソースファイルの行番号
  CSV.foreach("clear_source.csv") do |row|
    # csvからアドレス部分を取り出し連結
    address = [row[1], row[2], row[3]].join
    # 住所を2文字ずつに分割して配列化
    # その文字列が登場するソースファイルの行番号も入れておく
    bigram = address.each_char.each_cons(2).map{|chars| [chars.join, line_num] }

    # ひとまず一時変数に格納
    bigram.each do |ary|
      tmp_file << ary
    end
    line_num += 1
  end

  # ワード順、登場行順でソート
  tmp_file = tmp_file.sort_by {|record| [record[0], record[1]]}

  # 一時格納したデータをファイルに書き込み
  File.open("index_file.csv","w") do |file|
    tmp_file.each do |line|
      file.puts line.join(",")
    end
  end
end