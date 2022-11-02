module Mocha
  module ParameterMatchers
    def valid_payload_for(format_name)
      ValidSchemaMatcher.new(format_name)
    end

    class ValidSchemaMatcher < Base
      def initialize(format_name)
        super()
        @format_name = format_name
      end

      def matches?(available_parameters)
        payload = available_parameters.shift
        validator = GovukSchemas::Validator.new(@format_name, "publisher", JSON.dump(payload))
        validator.valid?
      end
    end
  end
end
