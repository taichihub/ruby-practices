# スコア計算
def calculate_score(throws)
  frames = throws.split(',').map { |t| t == 'X' ? 10 : t.to_i }
  frame_scores = []
  frame_index = 0

  10.times do |frame|
    if frames[frame_index] == 10 # ストライク
      score = 10 + frames[frame_index + 1] + frames[frame_index + 2]
      frame_index += 1
    elsif frames[frame_index] + frames[frame_index + 1] == 10 # スペア
      score = 10 + frames[frame_index + 2]
      frame_index += 2
    else
      score = frames[frame_index] + frames[frame_index + 1]
      frame_index += 2
    end
    frame_scores << score
  end

  frame_scores.sum
end

# メイン処理
def main_process
  puts "ーーーーーーーーーーーーー"
  puts "投球結果を入力してください"
  puts "ーーーーーーーーーーーーー"
  input_scores = gets.chomp
  total_score = calculate_score(input_scores)
  puts "ーーーーーーーーーーーーー"
  puts "スコア: #{total_score}"
  puts "ーーーーーーーーーーーーー"
end

# メイン処理実行
main_process 
