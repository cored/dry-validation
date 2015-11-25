require 'dry/validation/messages'
require 'dry/validation/error_compiler'

RSpec.describe Dry::Validation::ErrorCompiler do
  subject(:error_compiler) { Dry::Validation::ErrorCompiler.new(messages) }

  let(:messages) do
    Dry::Validation.Messages(
      attributes: {
        address: {
          filled?: 'Please provide your address'
        }
      }
    )
  end

  describe '#call' do
    let(:ast) do
      [
        [:error, [:input, [:name, nil, [:key, [:name, [:predicate, [:key?, []]]]]]]],
        [:error, [:input, [:age, 18, [:val, [:age, [:predicate, [:gt?, [18]]]]]]]],
        [:error, [:input, [:email, "", [:val, [:email, [:predicate, [:filled?, []]]]]]]],
        [:error, [:input, [:address, "", [:val, [:address, [:predicate, [:filled?, []]]]]]]]
      ]
    end

    it 'converts error ast into another format' do
      expect(error_compiler.(ast)).to eql([
        [:name, ["name is missing"]],
        [:age, ["age must be greater than 18 (18 was given)"]],
        [:email, ["email must be filled"]],
        [:address, ["Please provide your address"]]
      ])
    end
  end
end
