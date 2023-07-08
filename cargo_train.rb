require_relative 'validation'

class CargoTrain < Train
  include Validation
  
  def initialize(number)
    super
    @type = 'cargo'
  end
end
