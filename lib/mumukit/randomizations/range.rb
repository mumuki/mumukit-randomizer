class Mumukit::Randomizer::Randomization::Range < Mumukit::Randomizer::Randomization::Base
  def initialize(lower_bound, upper_bound)
    raise Mumukit::Randomizer::RandomizationFormatError, 'lower bound must be Numeric' unless lower_bound.is_a?(Numeric)
    raise Mumukit::Randomizer::RandomizationFormatError, 'upper bound must be Numeric' unless upper_bound.is_a?(Numeric)
    @choices = Range.new lower_bound, upper_bound
  end

  def get(value)
    modulo(value, choices)
  end
end
