class Mumukit::Randomizer::Randomization::Base
  attr_accessor :choices

  def size
    choices.size
  end

  def modulo(value, range)
    Random.new(value).rand(range)
  end

  def evaluate(seed, values)
    get seed
  end
end
