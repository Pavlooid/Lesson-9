class PassangerWagon < Wagon
  attr_reader :seats, :number, :type

  def initialize(seats, number)
    @number = number
    @type = 'Passanger'
    @seats = seats
    @taken_seats = 0
  end

  def take_seat
    if @seats > 0
      @seats -= 1
      @taken_seats += 1
    else
      puts 'No seats available!'
    end
  end

  def taken_seats
    print "Taken seats - #{@taken_seats}, "
  end

  def empty_seats
    print "Free seats - #{@seats},"
  end
end
