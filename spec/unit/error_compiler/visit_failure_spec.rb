RSpec.describe Dry::Validation::ErrorCompiler, '#visit_failure' do
  include_context :error_compiler

  let(:visitor) { :visit_failure }

  context 'with :int? predicate' do
    let(:node) do
      [:age, [:path, [:age, [:predicate, [:int?, [[:input, '17']]]]]]]
    end

    it 'returns a message for :int? failure with :rule name inferred from key-rule' do
      expect(result.rule).to be(:age)
      expect(result.path).to eql([:age])
      expect(result).to eql('must be an integer')
    end
  end

  context 'with each-rule failure and :int? predicate' do
    let(:node) do
      [:items, [:path, [:items, [:each, [
        [:path, [0, [:predicate, [:int?, [[:input, 'foo']]]]]],
        [:path, [2, [:predicate, [:int?, [[:input, 'bar']]]]]]
      ]]]]]
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

  context 'with a named set-rule failure and :key? predicate' do
    let(:node) do
      [:user, [:path, [:user, [:set, [
        [:predicate, [:key?, [[:name, :age], [:input, {}]]]],
        [:predicate, [:key?, [[:name, :email], [:input, {}]]]]
      ]]]]]
    end

    it 'returns a message for the :age key with :key? failure with :rule set explicitly' do
      expect(result[0].rule).to be(:user)
      expect(result[0].path).to eql([:user])
      expect(result[0]).to eql('is missing')
    end

    it 'returns a message for the :email key with :key? failure with :rule set explicitly' do
      expect(result[1].rule).to be(:user)
      expect(result[1].path).to eql([:user])
      expect(result[1]).to eql('is missing')
    end
  end
end
