# frozen_string_literal: true

module Addons
  class CreateAddonService < AddonService
    def execute
      return false unless @addon.save

      Addons::AnalyzePackageJob.perform_async @addon.id
      broadcast_to_clusters 'addons.created'
    end
  end
end
