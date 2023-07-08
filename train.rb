require_relative 'manufactor'
require_relative 'instance_counter'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passanger_wagon'
require_relative 'validation'
require 'pry'

class Train
  include InstanceCounter
  include Manufactor
  include Validation
  attr_accessor :speed, :wagons, :number, :type

  @@trains = []

  validate :number, :presence
  validate :number, :format, /^[а-яa-z\d]{3}[-]?[а-яa-z\d]{2}$/i

  def initialize(number)
    @speed = 0
    @number = number
    @wagons = []
    if valid?
      @@trains << self
      register_instance
    else
      validate!
    end
  end

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if speed.zero?
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if @speed.zero? && !@wagons.empty?
  end

  def set_route(route)
    @route = route
    route.stations.first.add_train(self)
    @index = 0
  end

  def move_forward
    current_station.send_train(self)
    next_station.add_train(self)
    @index += 1
  end

  def move_back
    current_station.send_train(self)
    last_station.add_train(self)
    @index -= 1
  end

  def current_station
    @route.stations[@index]
  end

  def next_station
    @route.stations[@index + 1]
  end

  def last_station
    @route.stations[@index - 1]
  end

  def print_wagons
    @wagons.each do |wagon|
      if wagon.type == 'Cargo'
        print "#{wagon.taken_space}#{wagon.empty_space} "
        puts "Number - #{wagon.number}, type - #{wagon.type}."
      else
        print "#{wagon.taken_seats}#{wagon.empty_seats} "
        puts "Number - #{wagon.number}, type - #{wagon.type}."
      end
    end
  end
end
