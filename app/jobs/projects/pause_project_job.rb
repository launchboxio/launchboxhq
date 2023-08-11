# frozen_string_literal: true

module Projects
  class PauseProjectJob
    include Sidekiq::Job

    # https://github.com/loft-sh/vcluster/blob/main/cmd/vclusterctl/cmd/pause.go
    def perform(project_id)
      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)
      client = @cluster.get_client("", 'v1')
      apps_client = @cluster.get_client("/apis/apps", 'v1')

      # Suspend the statefulset
      apps_client.patch_stateful_set(@project.slug, { spec: { replicas: 0 } }, @project.slug)

      # Delete created workloads
      pods = client.get_pods(namespace: @project.slug, label_selector: "vcluster.loft.sh/managed-by=#{@project.slug}")
      pods.each do |pod|
        client.delete_pod(pod.name, @project.slug)
      end
      @project.update(status: 'paused')
    end
  end
end