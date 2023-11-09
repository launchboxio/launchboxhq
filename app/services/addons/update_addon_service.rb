# frozen_string_literal: true

module Addons
  class UpdateAddonService < AddonService
    def execute
      return false unless @addon.save

      Addons::AnalyzePackageJob.perform_async @addon.id
      broadcast_to_clusters 'addons.updated'
    end
  end
end
