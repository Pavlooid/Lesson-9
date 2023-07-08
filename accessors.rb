module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(var_name) }
        old_values(name, var_name)
      end
    end

    def strong_attr_accessor(name, class_name)
      var_name = "#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value|
        if value.class != class_name
          'Value does not belong to class.'
        else
          instance_variable_set(var_name, value)
        end
      end
    end

    def old_values(name, var_name)
      define_method("#{name}".to_sym) do |value|
        instance_variable_set(var_name, value)
        old_name = "#{name}_old".to_sym
        old_value = instance_variable_get(old_name)
        add_or_edit_old_value(old_value, old_name, value, name)
      end
    end
  end

  module InstanceMethods
    def add_or_edit_old_value(old_value, old_name, value, name)
      if old_value
        instance_variable_set(old_name, old_value << value)
      else
        instance_variable_set(old_name, [value])
        self.class.send(:attr_reader, "#{name}_history".to_sym)
      end
    end
  end
end
