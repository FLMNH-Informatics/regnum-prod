module Restful
  module Formatters
    class JsonFormatter
      def format data, options
        build data, options.merge!(root: true)
      end

      private

      def build data, options, model_class = nil
        if data.nil?
          nil
        elsif data.respond_to?(:each)
          build_collection data, options, model_class || data.klass
        else
          build_entry data, options
        end
      end

      def build_collection collection, options, model_class
        show_root = options.delete(:root)
        out =
          collection.collect do |member|
            build_entry member, options
          end
        show_root ?
          { totalCount: collection.scoped.count,
            limit: collection.scoped.limit_value,
            model_class.collection_name => out
          } :
          out
      end

      def build_entry entry, options
        out = {}
        show_root = options.delete(:root)
        [*(options[:select]||'*')].each do |select|
          if select.to_s == '*'
            out.merge!(entry.attributes)
          else
            out[select] = entry.send(select)
          end
        end
        case options[:include]
        when Hash, Array
          options[:include].each do |k, v={}|
            out[k] = build(entry.send(k), v, entry.class.reflect_on_association(k.to_sym).klass)
          end
        when nil
        else # when Symbol, String, etc.
          out[options[:include]] =
            build(entry.send(options[:include]), {}, entry.class.reflect_on_association(options[:include].to_sym).klass)
        end
        show_root ? { entry.class.member_name => out } : out
      end
    end
  end
end