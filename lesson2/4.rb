vowels = ['a', 'e', 'i', 'o', 'u']
result = {}
counter = 1
('a'..'z').each do |letter|
  if vowels.any?(letter)
    result[letter] = counter
  end
  counter += 1
end

p result