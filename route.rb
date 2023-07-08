require_relative 'instance_counter'
require_relative 'validation'

class Route
  include InstanceCounter
  include Validation
  attr_reader :stations
  attr_accessor :first, :last

  def initialize(first, last)
    @stations = [first, last]
    if valid?
      register_instance
    else
      validate!
    end
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def delete(station)
    return if (station == @stations.first) || (station == @stations.last)
    @stations.delete(station)
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  protected

  def validate!
    raise 'Station array can not be empty.' if @stations.nil?
  end
end
