# frozen_string_literal: true

module Tenants
  class CreateTenantInstallationJob < ApplicationJob
    queue_as :default

    def perform(*args)
      # Do something later
    end
  end
end
