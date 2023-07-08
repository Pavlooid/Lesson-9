require_relative 'wagon'
require_relative 'train'
class CargoWagon < Wagon
  attr_accessor :space, :type, :number

  def initialize(space, number)
    @number = number
    @type = 'Cargo'
    @space = space
    @taken_space = 0
  end

  def take_space(space)
    if @space > 0
      @space -= space
      @taken_space += space
    else
      puts 'No available space!'
    end
  end

  def taken_space
    print "Taken space - #{@taken_space}, "
  end

  def empty_space
    print "Empty space - #{@space},"
  end
end
