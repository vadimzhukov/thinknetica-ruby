#validation of lengths input
def check_input(input)
  result = input.to_f
  while result <= 0
      print "Wrong value, try again: "
      result = gets.chomp.to_f
  end
  result
end

#identify if triangle is right (прямоугольный sic! :) ) using Pythgoras theory 
def is_triangle_right(sides)
  sides.max ** 2 == sides.sort[0..-2].reduce(0) {|acc, x| acc + x**2}
end

#identify if triangle is equilateral (равносторонний)
def is_triangle_quilateral(sides)
  sides.uniq.count == 1
end

#identify if triangle is isosceles (равнобедренный)
def is_triangle_isosceles(sides)
  sides.uniq.count == 2
end

puts "Input length of 3 sides of your triangle"
triangle_sides = []
3.times do |i|
  print "Side#{i+1}: "
  triangle_sides[i] = check_input(gets.chomp)
end

case 
when is_triangle_right(triangle_sides)
  puts "Your triangle is right (прямоугольный)"
when is_triangle_quilateral(triangle_sides)
  puts "Your triangle is quilateral (равносторонний)"
when is_triangle_isosceles(triangle_sides)
  puts "Your triangle is isosceles (равнобедренный)"
else
  puts "Your triangle is trivial :)"
end

