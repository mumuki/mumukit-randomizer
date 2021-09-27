module Mumukit
  class Randomizer
    def initialize(randomizations)
      @randomizations = randomizations
    end

    def with_seed(seed)
      values = []
      @randomizations.each_with_index do |(key, value), index|
        values.push([key, value.evaluate(seed + index, values)])
      end
      values
    end

    def randomized_values(seed)
      with_seed(seed).to_h
    end

    def randomize!(field, seed)
      with_seed(seed).inject(field) do |result, (replacee, replacer)|
        result.gsub "$#{replacee}", replacer.to_s
      end
    end

    alias randomize randomize!

    def self.parse(randomizations)
      new randomizations.with_indifferent_access.transform_values { |it| Mumukit::Randomizer::Randomization.parse it }
    end

    class RandomizationFormatError < StandardError
    end
  end
end

require 'keisan'
require_relative 'randomizations/randomization'
require_relative 'randomizations/base'
require_relative 'randomizations/one_of'
require_relative 'randomizations/range'
require_relative 'randomizations/expression'
require_relative 'randomizer/version'
