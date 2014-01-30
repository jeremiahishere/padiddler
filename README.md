# Padiddler

Sometimes data comes to you with a headlight out.

## Description

Maniuplate hashes from an external source so they work for your database setup.  Especially useful when reading data from external api or csv.  Instead of writing a messy conversion system, create easily testable Diddler objects to massage the data.

## Installation

Add this line to your application's Gemfile:

    gem 'padiddler'

## Usage

First, get a sample piece of input that needs diddling.  In this example, the first name and last name don't need extra processing but the date of birth should be renamed and turned into a Date object.

    input = {
      first_name: 'Jeremiah',
      last_name: 'Hemphill',
      tel_no: '555-1234',
      dob_year: '2014',
      dob_month: '1',
      dob_day: '24'
    }

Second, define your Diddler for the input

    PersonDiddler < Padiddler::Base
      # these instance variables should be made public with no changes
      keep :first_name, :last_name

      # these instance variable should be renamed in the output
      # in this case, the input key 'tel_no' will be called 'phone' in the output.
      rename :tel_no => :phone

      # this additional output should be added
      add :date_of_birth do
        Date.parse("#{@dob_year}/#{@dob_month}/#{@dob_day}")
      end
    end

Third, diddle away

    input = get_input_from_csv
    input.each_row do |row| 
      pdiddler = PersonDiddler.new(row)
      Person.create(pdiddler.diddle)
    end
