RSpec.describe Dry::Validation::ErrorCompiler, '#visit_failure' do
  include_context :error_compiler

  let(:visitor) { :visit_failure }

  context 'with an anonymous with key-rule failure and :int? predicate' do
    let(:node) do
      [nil, [:key, [:age, [:predicate, [:int?, [[:input, '17']]]]]]]
    end

    it 'returns a message for :int? failure with :rule name inferred from key-rule' do
      expect(result.rule).to be(:age)
      expect(result.path).to eql([:age])
      expect(result).to eql('must be an integer')
    end
  end

  context 'with an named failure with key-rule failure and :int? predicate' do
    let(:node) do
      [:age_check, [:key, [:age, [:predicate, [:int?, [[:input, '17']]]]]]]
    end

    it 'returns a message for :int? failure with :rule set explicitly' do
      expect(result.rule).to be(:age_check)
      expect(result.path).to eql([:age])
      expect(result).to eql('must be an integer')
    end
  end

  context 'with each-rule failure and :int? predicate' do
    let(:node) do
      [nil, [:each, [:items, [
        [:failure, [0, [:val, [:predicate, [:int?, [[:input, 'foo']]]]]]],
        [:failure, [2, [:val, [:predicate, [:int?, [[:input, 'bar']]]]]]]
      ]]]]
    end

    it 'returns a message for the first element that failed' do
      expect(result[0].rule).to be(:items)
      expect(result[0].path).to eql([:items, 0])
      expect(result[0]).to eql('must be an integer')
    end

    it 'returns a message for the third element that failed' do
      expect(result[1].rule).to be(:items)
      expect(result[1].path).to eql([:items, 2])
      expect(result[1]).to eql('must be an integer')
    end
  end
end
