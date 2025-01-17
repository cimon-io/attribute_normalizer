module AttributeNormalizer

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def normalize_attributes(*attributes, &block)
      options = attributes.last.is_a?(::Hash) ? attributes.pop : {}

      normalizers      = [ options[:with] ].flatten.compact
      normalizers      = [ options[:before] ].flatten.compact if block_given? && normalizers.empty?
      post_normalizers = [ options[:after] ].flatten.compact if block_given?

      if normalizers.empty? && !block_given?
        normalizers = AttributeNormalizer.configuration.default_normalizers # the default normalizers
      end

      attributes.each do |attribute|
        define_method "normalize_#{attribute}" do |value|
          normalized = value

          normalizers.each do |normalizer_name|
            unless normalizer_name.kind_of?(Symbol)
              normalizer_name, options = normalizer_name.keys[0], normalizer_name[ normalizer_name.keys[0] ]
            end
            normalizer = AttributeNormalizer.configuration.normalizers[normalizer_name]
            raise AttributeNormalizer::MissingNormalizer.new("No normalizer was found for #{normalizer_name}") unless normalizer
            normalized = normalizer.respond_to?(:normalize) ? normalizer.normalize( normalized , options) : normalizer.call(normalized, options)
          end

          normalized = block_given? ? instance_exec(normalized, &block) : normalized

          if block_given?
            post_normalizers.each do |normalizer_name|
              unless normalizer_name.kind_of?(Symbol)
                normalizer_name, options = normalizer_name.keys[0], normalizer_name[ normalizer_name.keys[0] ]
              end
              normalizer = AttributeNormalizer.configuration.normalizers[normalizer_name]
              raise AttributeNormalizer::MissingNormalizer.new("No normalizer was found for #{normalizer_name}") unless normalizer
              normalized = normalizer.respond_to?(:normalize) ? normalizer.normalize( normalized , options) : normalizer.call(normalized, options)
            end
          end

          normalized
        end

        self.send :private, "normalize_#{attribute}"

        if method_defined?(:"#{attribute}=")
          alias_method "old_#{attribute}=", "#{attribute}=" unless method_defined?(:"old_#{attribute}=")

          define_method "#{attribute}=" do |value|
            normalized_value = self.send(:"normalize_#{attribute}", value)
            self.send("old_#{attribute}=", normalized_value)
          end
        else
          define_method "#{attribute}=" do |value|
            super(self.send(:"normalize_#{attribute}", value))
          end
        end

      end
    end

    alias :normalize_attribute :normalize_attributes

  end

end
