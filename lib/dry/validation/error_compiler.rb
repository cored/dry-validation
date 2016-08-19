require 'dry/validation/message_compiler'

module Dry
  module Validation
    class ErrorCompiler < MessageCompiler
      def message_type
        :failure
      end

      def message_class
        Message
      end

      def visit_failure(node, opts = EMPTY_OPTS)
        rule, other = node
        visit(other, opts.(rule: rule))
      end

      def visit_each(node, opts = EMPTY_OPTS)
        node.map { |el| visit(el, opts.(each: true)) }
      end

      def lookup_options(opts, arg_vals = [])
        super.update(val_type: opts[:input].class)
      end
    end
  end
end
