RSpec.describe Dry::Validation::ErrorCompiler, '#visit' do
  include_context :error_compiler

  let(:visitor) { :visit }

  context 'with an anonymous :failure' do
    let(:node) do
      [:failure, [:age, [:path, [:age, [:predicate, [:int?, [[:input, '17']]]]]]]]
    end

    it 'returns a message for :int? failure with :rule name inferred from key-rule' do
      expect(result.rule).to be(:age)
      expect(result).to eql('must be an integer')
    end
  end
end
