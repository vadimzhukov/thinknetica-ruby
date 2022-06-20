puts "Input the base of triangle in cm:"
base = gets.chomp.to_f
puts "Input the height of triangle in cm:"
height = gets.chomp.to_f

square = (base * height / 2).round(4)

puts "The sqaure of the triangle is #{square}cm2"