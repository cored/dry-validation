RSpec.shared_context :error_compiler do
  subject(:compiler) { Dry::Validation::ErrorCompiler.new(messages) }

  let(:messages) do
    Dry::Validation::Messages.default
  end

  let(:result) do
    compiler.public_send(visitor, node)
  end
end
