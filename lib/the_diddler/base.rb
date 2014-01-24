module TheDiddler
  class Base
    
    class << self
      # defines which attributes should be used to generated the diddled output
      # note that attr_reader or attr_accessor can be used for the same purpose
      # maybe I should have just used those
      def attr_outputs(*outputs)
        outputs.each do |name|
          name = name.to_sym
          define_method(name) { instance_variable_get(instance_variable_name(name)) }
        end
      end 
      alias :attr_output :attr_outputs
    end

    # Turns a hash into instance variables based on top level keys
    # if the top level key is pointing to a hash, the value is not changed
    def initialize(input = {})
      input.each_pair do |key, value|
        instance_variable_set(instance_variable_name(key), value)
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

    private

    # convenience method for turning a string into an instance variable symbol
    # will take a string or symbol as an argument
    # will add one @ to the front of the input
    def instance_variable_name(name)
      "@#{name.to_s}".to_sym
    end
  end
end
