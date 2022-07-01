class TestTrain
  @instances = 0

  def initialize(number, type = :passenger)
    @number = number
    @type = type
    register_instance
  end

  def self.instances 
    @instances
  end

  private
  def self.increase_instance
    @instances ||= 0
    @instances += 1
  end

  def register_instance
    self.class.send :increase_instance
  end
end

class TestPassengerTrain < TestTrain
  def initialize(number)
    super(number, :passenger)
  end
end

class TestCargoTrain < TestTrain
  def initialize(number)
    super(number, :passenger)
  end
end


tr1 = TestTrain.new("MMM_NUM1")
tr2 = TestTrain.new("MMM_NUM2")
tr3 = TestTrain.new("MMM_NUM3")

pas1 = TestPassengerTrain.new("PAS1")
pas2 = TestPassengerTrain.new("PAS2")

car1 = TestCargoTrain.new("CAR1")
car2 = TestCargoTrain.new("CAR2")
car3 = TestCargoTrain.new("CAR3")
car4 = TestCargoTrain.new("CAR4")

puts "Train: #{TestTrain.instances}"
puts "PasTrain: #{TestPassengerTrain.instances}"
puts "CargoTrain: #{TestCargoTrain.instances}"
