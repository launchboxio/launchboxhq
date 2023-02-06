class Clusters::TestClusterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @cluster = Cluster.find(args.first)
    cert_store = OpenSSL::X509::Store.new
    cert_store.add_cert(OpenSSL::X509::Certificate.new(@cluster.ca_crt))
    @options = {
      auth_options: { bearer_token: @cluster.token },
      ssl_options: {
        cert_store: cert_store,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER
      }
    }
    client = Kubeclient::Client.new("#{@cluster.host}/api", 'v1', **@options)
    pods = client.get_pods
    puts pods.inspect
  end
end
