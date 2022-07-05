module Iterators
  def iterate_trains(block)
    trains.each {|tr| block.call(tr)}
  end
  def iterate_wagons(block)
    wagons.each {|w| block.call(w)}
  end
end
