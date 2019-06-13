require "./search.rb"
require "./make_index.rb"

puts "実行したい処理の番号を入力してください"
puts "1. インデックスファイル作成"
puts "2. 住所検索"

selected_no = gets.to_i

if selected_no == 1
  puts ""
  puts "インデックスファイルの作成を開始します"
  puts "~作成中~"
  make_index
  puts "インデックスファイルの作成が完了しました"
elsif selected_no == 2
  search_address
else
  puts "半角数字の1か2を入力してください"
  puts "アプリケーションを終了します"
end