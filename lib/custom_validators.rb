module Custom
  class Validators

    class << self

      def check_string_as_float(string)
        true if Float(string) rescue false
      end

      def validate_coordinates_with_message(latitude, longitude, message)
        raise message unless check_string_as_float(latitude) && check_string_as_float(longitude)
      end

    end

  end
end

