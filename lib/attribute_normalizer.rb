Dir[File.join(__dir__, 'attribute_normalizer', 'normalizers', '*.rb')].each { |file| require file }

module AttributeNormalizer

  class MissingNormalizer < ArgumentError; end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end


  class Configuration
    attr_accessor :default_normalizers, :normalizers

    def default_normalizers=(normalizers)
      @default_normalizers = normalizers.is_a?(Array) ? normalizers : [ normalizers ]
    end

    def initialize

      @normalizers = {
        :blank                => AttributeNormalizer::Normalizers::BlankNormalizer,
        :phone                => AttributeNormalizer::Normalizers::PhoneNormalizer,
        :squish               => AttributeNormalizer::Normalizers::SquishNormalizer,
        :strip                => AttributeNormalizer::Normalizers::StripNormalizer,
        :whitespace           => AttributeNormalizer::Normalizers::WhitespaceNormalizer,
        :boolean              => AttributeNormalizer::Normalizers::BooleanNormalizer,
        :control_chars        => AttributeNormalizer::Normalizers::ControlCharsNormalizer,
        :url                  => AttributeNormalizer::Normalizers::UrlNormalizer,
        :date                 => AttributeNormalizer::Normalizers::DateStrNormalizer,
        :reject_blank         => AttributeNormalizer::Normalizers::ArrayEmptyStringNormalizer,
        :integer              => AttributeNormalizer::Normalizers::IntegerNormalizer,
        :name                 => AttributeNormalizer::Normalizers::NameNormalizer,
      }

      @default_normalizers = [ :strip, :blank ]

    end

  end

end


require 'attribute_normalizer/model_inclusions'
require 'attribute_normalizer/rspec_matcher'

def include_attribute_normalizer(class_or_module)
  return if class_or_module.include?(AttributeNormalizer)
  class_or_module.class_eval do
    extend AttributeNormalizer::ClassMethods
  end
end


include_attribute_normalizer(ActiveModel::Base)     if defined?(ActiveModel::Base)
include_attribute_normalizer(ActiveRecord::Base)    if defined?(ActiveRecord::Base)
include_attribute_normalizer(CassandraObject::Base) if defined?(CassandraObject::Base)
