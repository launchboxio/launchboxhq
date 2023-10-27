# frozen_string_literal: true

module Projects
  class DeleteProjectJob
    include Sidekiq::Job

    def perform(project_id)
      @project = Project.find(project_id)
      @project.update(status: :terminating)
      @cluster = Cluster.find(@project.cluster_id)

      # Get the version
      client = @cluster.get_client('/apis/cluster.x-k8s.io', 'v1beta1')
      client.delete_cluster(@project.slug, @project.slug)

      client = @cluster.get_client('/apis/infrastructure.cluster.x-k8s.io', 'v1alpha1')
      client.delete_vcluster(@project.slug, @project.slug)

      client = @cluster.get_client('', 'v1')
      client.delete_namespace(@project.slug)
      @project.update(status: :terminated)
    end
  end
end
