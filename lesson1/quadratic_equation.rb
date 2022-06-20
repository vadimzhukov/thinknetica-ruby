def discriminant(a, b, c)
  b**2 - 4 * a * c
end

def roots(d, a, b)
  x = []
  x[0] = ((- b + Math.sqrt(d)) / 2 * a).round(8)
  x[1] = ((- b - Math.sqrt(d)) / 2 * a).round(8)
  return x
end

puts "Input a, b, c coefficients of your quadratic equation"
coefficients = {}
["a", "b", "c"].each do |i|
  print "#{i}: "
  coefficients[i] = gets.chomp.to_f
end

a, b, c = coefficients.values
d = discriminant(a, b, c)
if d >= 0 
  puts  "The roots of your equation are: #{roots(d, a, b)}"
else
  puts "Your equation doesn't have roots"
end