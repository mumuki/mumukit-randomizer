class Mumukit::Randomizer::Randomization::Expression < Mumukit::Randomizer::Randomization::Base

  def initialize(keisan_code)
    Keisan::AST.parse keisan_code

    @keisan_code = keisan_code
    @calculator = new_calculator
  rescue Keisan::Exceptions::BaseError => e
    raise Mumukit::Randomizer::RandomizationFormatError, "Malformed randomization expression: #{e.message}. See docs here https://github.com/project-eutopia/keisan"
  end

  def new_calculator
    Keisan::Calculator.new.tap do |calculator|
      calculator.define_function! "to_s", proc {|x| x.to_s }
      calculator.define_function! "to_i", proc {|x| x.to_i }
    end
  end

  def evaluate(seed, values)
    @calculator.evaluate(interpolated_keisan_code(values), {seed: seed}.merge(values.to_h))
  end

  def interpolated_keisan_code(values)
    Mumukit::Randomizer.interpolate_all @keisan_code, values
  end
end
