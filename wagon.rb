require_relative 'manufactor'

class Wagon
  include Manufactor
  attr_reader :type
end
