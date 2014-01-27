module Padiddler
  class Base
    
    class << self
      # defines which attributes should be used in the output without changing their values
      # 
      # @param Array outputs an array of strings or symbols that correspond to instance variable names
      def keep(*outputs)
        outputs.each do |name|
          instance_variable_accessor(name, name)
        end
      end 

      # defines outputs whose names do not match the name of their instance variable
      #
      # @param Hash outputs Each pair should have the format :new_name => :original_name
      def rename(outputs)
        outputs.each_pair do |public_name, instance_var_name|
          instance_variable_accessor(instance_var_name, public_name)
        end
      end

      # adds a new output that is not directly related to an instance variable
      # here to keep things consistent
      #
      # note that this functionality can be duplicated by just defining methods
      #
      # @param Symbol name The name of the output
      def add(name, &block)
        define_method(name.to_sym) { yield block }
      end 

      private

      # create a name accessor for an instance variable
      def instance_variable_accessor(var_name, name)
        instance_var = instance_variable_name(var_name) 
        define_method(name) { instance_variable_get(instance_var) }
      end

      # convenience method for turning a string into an instance variable symbol
      # will take a string or symbol as an argument
      # will add one @ to the front of the input
      def instance_variable_name(name)
        "@#{name.to_s}".to_sym
      end
    end

    # Turns a hash into instance variables based on top level keys
    # if the top level key is pointing to a hash, the value is not changed
    def initialize(input = {})
      input.each_pair do |key, value|
        instance_variable_set(self.class.send(:instance_variable_name, key), value)
      end
    end 

    # gets a list of public methods, assigns their name and value to a hash, and returns
    # ignores private methods and methods that require arguments
    def diddle
      output = {}
      output_methods = public_methods(false).select { |m| method(m).arity == 0 && m != :diddle }
      output_methods.each do |name|
        output[name] = send(name)
      end
      output
    end 
  end
end
