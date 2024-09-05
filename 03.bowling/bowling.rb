MAX_PINS = 10

# スコア計算
def calculate_score(throws)
  throw_result = throws.split(',').map { |t| t == 'X' ? 10 : t.to_i }
  frame_scores = []
  frame_index = 0

  frame_scores = 10.times.map do
    if throw_result[frame_index] == MAX_PINS # ストライク
      score = MAX_PINS + throw_result[frame_index + 1] + throw_result[frame_index + 2]
      frame_index += 1
    elsif throw_result[frame_index] + throw_result[frame_index + 1] == MAX_PINS # スペア
      score = MAX_PINS + throw_result[frame_index + 2]
      frame_index += 2
    else
      score = throw_result[frame_index] + throw_result[frame_index + 1]
      frame_index += 2
    end
    score 
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
