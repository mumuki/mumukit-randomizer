class Mumukit::Randomizer::Randomization::Expression < Mumukit::Randomizer::Randomization::Base

  def initialize(keisan_code)
    @keisan_code = keisan_code
    @calculator = new_calculator
  end

  def new_calculator
    Keisan::Calculator.new.tap do |calculator|
      calculator.define_function! "to_s", proc {|x| x.to_s }
      calculator.define_function! "to_i", proc {|x| x.to_i }
    end
  end

  def evaluate(seed, values)
    @calculator.evaluate(@keisan_code, {seed: seed}.merge(values.to_h))
  end
end
