module Mumukit::Randomizer::Randomization
  attr_accessor :randomizations

  def initialize(randomizations)
    @randomizations = randomizations
  end

  def self.parse(randomization)
    case randomization[:type].to_sym
      when :one_of then Mumukit::Randomizer::Randomization::OneOf.new randomization[:value]
      when :range then Mumukit::Randomizer::Randomization::Range.new(*randomization[:value])
      when :expression then Mumukit::Randomizer::Randomization::Expression.new(*randomization[:value])
      else raise Mumukit::Randomizer::RandomizationFormatError, 'Unsupported randomization kind'
    end
  end
end
