module TestClassMethods
  attr_reader :instances

  private
  def increase_instance
    @instances ||= 0
    @instances += 1
  end
end

module TestInstanceMethods
  private
  def register_instance
    self.class.send :increase_instance
  end
end

class TestTrain
  extend TestClassMethods
  include TestInstanceMethods

  def initialize(number, type = :passenger)
    @number = number
    @type = type
    register_instance
  end

end

class TestPassengerTrain < TestTrain
end

class TestCargoTrain < TestTrain
end

tr1 = TestTrain.new("MMM_NUM1")
tr2 = TestTrain.new("MMM_NUM2")
tr3 = TestTrain.new("MMM_NUM3")

pas1 = TestPassengerTrain.new("PAS1")
pas2 = TestPassengerTrain.new("PAS2")
pas3 = TestPassengerTrain.new("PAS3")
pas4 = TestPassengerTrain.new("PAS4")

car1 = TestCargoTrain.new("CAR1")
car2 = TestCargoTrain.new("CAR2")
car3 = TestCargoTrain.new("CAR3")
car4 = TestCargoTrain.new("CAR4")
car5 = TestCargoTrain.new("CAR5")

puts "Trains: #{TestTrain.instances}"
puts "Passenger: #{TestPassengerTrain.instances}"
puts "Cargo: #{TestCargoTrain.instances}"