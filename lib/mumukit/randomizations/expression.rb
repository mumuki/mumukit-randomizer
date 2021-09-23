class Mumukit::Randomizer::Randomization::Expression < Mumukit::Randomizer::Randomization::Base
  def initialize(keisan_code)
    @keisan_code = keisan_code
  end

  def evaluate(seed, values)
    Keisan::Calculator.new.evaluate(@keisan_code, {seed: seed}.merge(values.to_h))
  end
end
