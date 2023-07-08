module Manufactor
  attr_accessor :manufactor

  def initialize(manufactor)
    @manufactor = manufactor
  end

  protected

  def validate!
    raise 'Название производителя не может быть пустым!' if @manufactor.nil?
  end
end
