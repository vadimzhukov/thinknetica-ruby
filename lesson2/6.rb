puts "Введите название товара, его стоимость и количество. Для завершения ввода введите слово \"стоп\" вместо названия товара"

goods = {}
loop do
title = gets.chomp
if title.downcase == "стоп"
  break
end
price = gets.chomp.to_f
count = gets.chomp.to_f

# добавляем товар в хэш попутно проверяя есть ли уже такой товар и есть ли количество по такой цене
if goods[title].nil?
  goods[title] = {price => count}
elsif goods[title][price].nil?
  goods[title].merge!({price => count})
else
  goods[title][price] += count
end

end

# вычисляем итоговую стоимость каждого товара и 
total_price ={}

goods.each do |title, price_count|
  price_count.each do |price, count|
    if total_price[title].nil? 
      total_price[title] = price * count
    else
      total_price[title] += price * count
    end
  end
end

cart_price = 0
total_price.each do |title, price|
  cart_price += price
end

puts "Список товаров: #{goods}"
puts "Итоговая сумма по каждому товару: #{total_price}"
puts "Стоимость товаров в корзине: #{cart_price}"