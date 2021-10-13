require 'spec_helper'

describe Mumukit::Randomizer do

  describe '#with_seed' do
    before { Mumukit::Randomizer::Randomization::Base.any_instance.stub(:modulo) { |_, value, range| value % range.size + range.first } }

    let(:randomizer) do
      Mumukit::Randomizer.parse(
        some_string: { type: :one_of, value: %w(some string) },
        some_number: { type: :range, value: [1, 3] }
      )
    end

    it { expect(randomizer.with_seed 0).to eq([['some_string', 'some'],    ['some_number', 2]]) }
    it { expect(randomizer.with_seed 1).to eq([['some_string', 'string'],  ['some_number', 3]]) }
    it { expect(randomizer.with_seed 2).to eq([['some_string', 'some'],    ['some_number', 1]]) }
    it { expect(randomizer.with_seed 3).to eq([['some_string', 'string'],  ['some_number', 2]]) }
    it { expect(randomizer.with_seed 4).to eq([['some_string', 'some'],    ['some_number', 3]]) }
    it { expect(randomizer.with_seed 5).to eq([['some_string', 'string'],  ['some_number', 1]]) }
    it { expect(randomizer.with_seed 6).to eq([['some_string', 'some'],    ['some_number', 2]]) }
  end


  context 'invalid format' do
    it { expect { Mumukit::Randomizer.parse x: { type: :expression, value: "}"} }.to raise_error Mumukit::Randomizer::RandomizationFormatError, 'Malformed randomization expression: Tokenizing error, unexpected closing brace }. See docs here https://github.com/project-eutopia/keisan' }
    it { expect { Mumukit::Randomizer.parse x: { type: :range, value: ["a", "b"]} }.to raise_error Mumukit::Randomizer::RandomizationFormatError, 'lower bound must be Numeric' }
  end

  describe Mumukit::Randomizer::Randomization::Expression do
    let(:randomizer) do
      Mumukit::Randomizer.parse(
        a: { type: :range, value: [1, 10] },
        b: { type: :range, value: [1, 10] },
        some_expression: { type: :expression, value: expression }
      )
    end

    context 'math expression' do
      let(:expression) { 'a + 2 * b' }

      it { expect(randomizer.randomized_values(1)).to eq 'a' => 6, 'b' => 9, 'some_expression' => 24 }
      it { expect(randomizer.randomized_values(4)).to eq 'a' => 8, 'b' => 4, 'some_expression' => 16 }
      it { expect(randomizer.randomized_values(6)).to eq 'a' => 10, 'b' => 5, 'some_expression' => 20 }
    end

    context 'conversion expressions' do
      let(:expression) { 'a.to_s + b.to_s' }

      it { expect(randomizer.randomized_values(1)).to eq 'a' => 6, 'b' => 9, 'some_expression' => '69' }
      it { expect(randomizer.randomized_values(4)).to eq 'a' => 8, 'b' => 4, 'some_expression' => '84' }
      it { expect(randomizer.randomized_values(6)).to eq 'a' => 10, 'b' => 5, 'some_expression' => '105' }
    end

    context 'conversion expressions' do
      let(:expression) { '(a.to_s + b.to_s).to_i' }

      it { expect(randomizer.randomized_values(1)).to eq 'a' => 6, 'b' => 9, 'some_expression' => 69 }
      it { expect(randomizer.randomized_values(4)).to eq 'a' => 8, 'b' => 4, 'some_expression' => 84 }
      it { expect(randomizer.randomized_values(6)).to eq 'a' => 10, 'b' => 5, 'some_expression' => 105 }
    end

    context 'list expressions' do
      let(:expression) { 'map([a, 1.5 * b, 11], x, x - 1).min' }

      it { expect(randomizer.randomized_values(1)).to eq 'a' => 6, 'b' => 9, 'some_expression' => 5 }
      it { expect(randomizer.randomized_values(4)).to eq 'a' => 8, 'b' => 4, 'some_expression' => 5.0 }
      it { expect(randomizer.randomized_values(6)).to eq 'a' => 10, 'b' => 5, 'some_expression' => 6.5 }
    end

    context 'if expressions' do
      let(:randomizer) do
        Mumukit::Randomizer.parse(
          option: { type: :one_of, value: ["first option", "second option"] },
          explain: { type: :expression, value: "if (option == 'first option', 'do this', 'do that')" },
          example: { type: :expression, value: "if (option == 'first option', 'an example', 'other example')" },
        )
      end

      it { expect(randomizer.randomized_values(1)).to eq 'option' => 'second option', 'explain' => 'do that', 'example' => 'other example' }
      it { expect(randomizer.randomized_values(2)).to eq 'option' => 'first option', 'explain' => 'do this', 'example' => 'an example' }

      it { expect(randomizer.randomize("> We need $option - $explain. E.g. $example", 2)).to eq "> We need first option - do this. E.g. an example" }
    end

    context 'expression with full interpolation' do
      context 'valid interpolation location' do
        let(:expression) { '"19$a$b"' }

        it { expect(randomizer.randomized_values(4)).to eq 'a' => 8, 'b' => 4, 'some_expression' => "1984" }
      end

      context 'invalid interpolation location' do
        let(:expression) { '19$a$b' }

        it { expect { randomizer }.to raise_error Mumukit::Randomizer::RandomizationFormatError }
      end
    end
  end

  it 'has a version number' do
    expect(Mumukit::Randomizer::VERSION).not_to be nil
  end
end
