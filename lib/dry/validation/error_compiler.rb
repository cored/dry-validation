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
        name, other = node

        if name && opts.path?
          visit(other, opts.(path: name))
        elsif name
          visit(other, opts.(rule: name))
        else
          visit(other, opts)
        end
      end

      def visit_each(node, opts = EMPTY_OPTS)
        path, items = node
        items.map { |el| visit(el, opts.(rule: path, path: path, each: true)) }
      end

      def lookup_options(opts, arg_vals = [])
        super.update(val_type: opts[:input].class)
      end
    end
  end
end
