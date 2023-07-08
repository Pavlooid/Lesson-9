require_relative 'validation'

class PassangerTrain < Train
  include Validation
  
  def initialize(number)
    super
    @type = 'passanger'
  end
end
