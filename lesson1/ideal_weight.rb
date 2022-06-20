puts "What is your name?"
name = gets.chomp
puts "What is your height in cm?"
height = gets.chomp

ideal_weight = ((height.to_f - 110) * 1.15).round(4)

if ideal_weight >= 0 
  puts "#{name}, your ideal weight is #{ideal_weight}kg"
else
  puts "#{name}, your weight is allready perfect"
end
