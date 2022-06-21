fib = [0]
counter = 1
i = 1
while i <= 100
  fib[counter] = i
  i = fib[counter] + fib[counter - 1]
  counter += 1
end

p fib