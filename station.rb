require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation
  attr_reader :trains, :name

  @@stations = []

  validate :name, :presence

  def initialize(name)
    @name = name
    @trains = []
    if valid?
      @@stations << self
      register_instance
    else
      validate!
    end
  end

  def self.all
    @@stations
  end

  def add_train(train)
    @trains << train
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  def send_train(train)
    @trains.delete(train)
  end

  def print_trains
    @trains.each do |train|
      print "Number-#{train.number}, type-#{train.type}, "
      puts "wagons-#{train.wagons.size}."
    end
  end
end
