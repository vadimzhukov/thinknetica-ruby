months = {1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 
  7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31}


puts "Введите интересующий день, месяц, год:"
day = gets.chomp.to_i
month = gets.chomp.to_i
year = gets.chomp.to_i

unless year % 4 != 0 || (year % 100 == 0 && year % 400 != 0)  #алгоритм определения високосного года
  months[2] = 29 #високосный год
end

days_to_start_of_month = 0
(1...month).each do |m|
  days_to_start_of_month += m * months[m]
end

result = day + days_to_start_of_month

puts "Дней с начала #{year.to_s} года до выбранного дня: #{result}"