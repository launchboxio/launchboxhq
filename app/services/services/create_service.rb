# frozen_string_literal: true

module Services
  class CreateService
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def execute
      true
    end
  end
end
