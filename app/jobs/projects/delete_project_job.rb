# frozen_string_literal: true
module Projects
  class DeleteProjectJob
    include Sidekiq::Job

    def perform(project_id)
      @project = Project.find(project_id)
      @project.update(status: "terminating")
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

      # Get the version
      client = Kubeclient::Client.new("#{@cluster.host}/apis/cluster.x-k8s.io", 'v1beta1', **@options)
      client.delete_cluster(@project.slug, @project.slug)

      client = Kubeclient::Client.new("#{@cluster.host}/apis/infrastructure.cluster.x-k8s.io", 'v1alpha1', **@options)
      client.delete_vcluster(@project.slug, @project.slug)

      client = Kubeclient::Client.new(@cluster.host, 'v1', **@options)
      client.delete_namespace(@project.slug)
      @project.update(status: 'terminated')
    end
  end
end