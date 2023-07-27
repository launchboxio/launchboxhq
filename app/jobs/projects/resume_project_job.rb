# frozen_string_literal: true

module Projects
  class ResumeProjectJob
    include Sidekiq::Job

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

      apps_client = Kubeclient::Client.new("#{@cluster.host}/apis/apps", 'v1', **@options)
      apps_client.patch_stateful_set(@project.slug, { spec: { replicas: 1 } }, @project.slug)

      @project.update(status: 'started')
    end
  end
end