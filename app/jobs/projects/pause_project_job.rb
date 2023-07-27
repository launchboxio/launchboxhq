# frozen_string_literal: true

module Projects
  class PauseProjectJob
    include Sidekiq::Job

    # https://github.com/loft-sh/vcluster/blob/main/cmd/vclusterctl/cmd/pause.go
    def perform(project_id)
      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_cert(OpenSSL::X509::Certificate.new(@cluster.ca_crt))
      @options = {
        auth_options: { bearer_token: @cluster.token },
        ssl_options: {
          cert_store: cert_store,
          verify_ssl: OpenSSL::SSL::VERIFY_PEER
        }
      }
      client = Kubeclient::Client.new(@cluster.host, 'v1', **@options)
      apps_client = Kubeclient::Client.new("#{@cluster.host}/apis/apps", 'v1', **@options)

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