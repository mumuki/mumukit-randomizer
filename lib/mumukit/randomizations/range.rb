class Mumukit::Randomizer::Randomization::Range < Mumukit::Randomizer::Randomization::Base
  def initialize(lower_bound, upper_bound)
    raise 'Range bounds must be Numeric' unless lower_bound.is_a?(Numeric) && upper_bound.is_a?(Numeric)
    @choices = Range.new lower_bound, upper_bound
  end

  def get(value)
    modulo(value, choices)
  end
end
