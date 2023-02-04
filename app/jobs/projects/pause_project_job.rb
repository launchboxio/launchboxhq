# frozen_string_literal: true

module Projects
  class PauseProjectJob < ApplicationJob
    queue_as :default

    # https://github.com/loft-sh/vcluster/blob/main/cmd/vclusterctl/cmd/pause.go
    def perform(*args)
      @project = Project.find(args.first)
      @options = {
        auth_options: { bearer_token: @project.cluster.token },
        ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
      }
      client = Kubeclient::Client.new(@project.cluster.host, 'v1', **options)
      apps_client = Kubeclient::Client.new("#{@project.cluster.host}/apis/apps", 'v1', **options)

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