# TheDiddler

Maniuplate hashes from an external source so they work for your database setup.  Especially useful when reading data from external api or csv.  Instead of writing a messy conversion system, create easily testable Diddler objects to massage the data.

## Installation

Add this line to your application's Gemfile:

    gem 'the_diddler'

## Usage

First, get a sample piece of input that needs diddling.  In this example, the first name and last name don't need extra processing but the date of birth should be renamed and turned into a Date object.

    input = {
      first_name: 'Jeremiah',
      last_name: 'Hemphill',
      dob_year: '2014',
      dob_month: '1',
      dob_day: '24'
    }

Second, define your Diddler for the input

    PersonDiddler < TheDiddler::Base
      attr_output :first_name, :last_name

      def date_of_birth
        Date.parse("#{@dob_year}/#{@dob_month}/#{@dob_day}")
      end
    end

Third, diddle away

    input = get_input_from_csv
    diddler = PersonDiddler.new(input)
    Person.create(diddler.diddle)
