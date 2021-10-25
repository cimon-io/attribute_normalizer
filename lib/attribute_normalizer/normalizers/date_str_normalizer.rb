module AttributeNormalizer
  module Normalizers
    class DateStrNormalizer
      def self.normalize(value, options = {})
        Date.strptime(result, options.fetch(:date_format, '%d/%m/%Y %H:%M'))
      rescue Date::Error
        options.fetch(:default_date, nil)
      end
    end
  end
end
