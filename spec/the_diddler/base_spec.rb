require 'spec_helper'

# the sample class to test on
class SampleDiddler < TheDiddler::Base
end

describe TheDiddler::Base do
  # after running each test, remove the methods we have added
  after(:each) do
    diddler = SampleDiddler.new({})
    SampleDiddler.send(:remove_method, :first_name) if diddler.respond_to? :first_name
    SampleDiddler.send(:remove_method, :middle_name) if diddler.respond_to? :middle_name
    SampleDiddler.send(:remove_method, :last_name) if diddler.respond_to? :last_name
  end

  describe 'attr_outputs' do
    it 'should take a list of symbols and define multiple instance methods' do
      SampleDiddler.attr_outputs(:first_name, :last_name)
      diddler = SampleDiddler.new
      expect(diddler).to respond_to(:first_name)
      expect(diddler).to respond_to(:last_name)
    end

    it 'should take a single symbol and define one instance method' do
      SampleDiddler.attr_outputs(:middle_name)
      diddler = SampleDiddler.new
      expect(diddler).to respond_to(:middle_name)
    end

    it 'should also be callable through attr_output' do
      SampleDiddler.attr_output(:middle_name)
      diddler = SampleDiddler.new
      expect(diddler).to respond_to(:middle_name)
    end
  end

  describe 'initialize' do
    it 'should iterate over the hash and create instance variables' do
      diddler = SampleDiddler.new(first_name: 'Jeremiah')
      expect(diddler.instance_variables).to include(:@first_name)
      expect(diddler.instance_variable_get(:@first_name)).to eq('Jeremiah')
    end
  end

  describe 'diddle' do
    before(:each) do
      @diddler = SampleDiddler.new(first_name: 'Jeremiah', last_name: 'Hemphill')
    end

    it 'should iterate over public methods and return their outputs' do
      def @diddler.first_name
        @first_name
      end

      expect(@diddler.diddle).to eq(first_name: 'Jeremiah')
    end

    it 'should not include keys in the hash that were not excplicitly made public' do
      expect(@diddler.diddle.keys).not_to include(:last_name)
    end

    it 'should not include private methods' do
      SampleDiddler.send(:define_method, :first_name) do
        @first_name
      end
      SampleDiddler.instance_eval { private :first_name }

      expect(@diddler.diddle.keys).not_to include(:first_name)
    end

    it 'should not include methods that require arguments' do
      def @diddler.first_name(arg)
        @first_name + arg
      end

      expect(@diddler.diddle.keys).not_to include(:first_name)
    end
  end
end
