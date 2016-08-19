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

      def visit_failure(node, opts = EMPTY_HASH)
        name, other = node

        if name && opts[:path]
          visit(other, opts.merge(path: [*opts[:path], *name]))
        elsif name
          visit(other, opts.merge(rule: name))
        else
          visit(other, opts)
        end
      end

      def visit_each(node, opts = EMPTY_HASH)
        path, items = node
        items.map { |el| visit(el, opts.merge(rule: path, path: path, each: true)) }
      end

      def visit_check(node, opts = EMPTY_HASH)
        name, other = node

        if opts[:schema]
          visit(other, opts)
        else
          visit(other, opts.merge(path: Array(name)))
        end
      end

      def lookup_options(opts, arg_vals = [])
        super.update(val_type: opts[:input].class)
      end
    end
  end
end
