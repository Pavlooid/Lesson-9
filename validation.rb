module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(attr_name, validation, args = '')
      self.validations ||= []
      validations << { validation => {name: attr_name, params: args }  }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        validation.each do |type, args|
          variable = instance_variable_get("@#{args[:name]}")
          send(type, variable, args[:params])
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def presence(name, args)
      text = "Attribute name can not be nill or empty."
      raise text if name.nil? || name.empty?
    end

    def format(name, regexp)
      text = "Attribute #{name} must meet regexp #{regexp} validaton."
      raise text unless name =~ regexp

    def type(name, class_name)
      text = "Attribute #{name} class not = #{class_name}"
      raise text if name.class != class_name
    end

    end
  end
end
