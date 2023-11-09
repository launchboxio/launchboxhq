# frozen_string_literal: true

module Addons
  class DeleteAddonService < AddonService
    def execute
      # Simply mark the addon as deleting
      @addon.status = 'pending-deletion'
      return false unless @addon.save

      Addons::AnalyzePackageJob.perform_async @addon.id
      broadcast_to_clusters 'addons.deleted'
      true
    end
  end
end
