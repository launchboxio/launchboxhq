class SyncDeveloperSpaceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts args
    # Connect to the cluster / agent
    # Create / Update the VCluster CRD on the cluster
    @space = Space.find(args.first)

    auth_options = {
      bearer_token: @space.cluster.token
    }
    ssl_options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }

    # Ensure the namespace exists
    client = Kubeclient::Client.new(
      @space.cluster.host, 'v1', auth_options: auth_options, ssl_options: ssl_options
    )

    begin
      client.create_namespace(Kubeclient::Resource.new({ metadata: { name: @space.slug } }))
    rescue Kubeclient::HttpError => error
      if error.error_code == 409
        # client.patch_namespace(space.slug, namespace)
      end
    end

    # Create the ClusterAPI cluster object

    cluster_client = Kubeclient::Client.new(
      "#{@space.cluster.host}/apis/cluster.x-k8s.io", 'v1beta1', auth_options: auth_options, ssl_options: ssl_options
    )
    cluster_client.discover

    cluster = Kubeclient::Resource.new
    cluster.kind = "Cluster"
    cluster.metadata = {}
    cluster.metadata.name = @space.slug
    cluster.metadata.namespace = @space.slug
    cluster.spec = {}
    cluster.spec.controlPlaneRef = {}
    cluster.spec.controlPlaneRef.apiVersion = "infrastructure.cluster.x-k8s.io/v1alpha1"
    cluster.spec.controlPlaneRef.kind = "VCluster"
    cluster.spec.controlPlaneRef.name = @space.slug

    cluster.spec.infrastructureRef = {}
    cluster.spec.infrastructureRef.apiVersion = "infrastructure.cluster.x-k8s.io/v1alpha1"
    cluster.spec.infrastructureRef.kind = "VCluster"
    cluster.spec.infrastructureRef.name = @space.slug

    begin
      cluster_client.create_cluster(cluster)
    rescue Kubeclient::HttpError => error
      if error.error_code == 409
        cluster_client.merge_patch_cluster(@space.slug, cluster, @space.slug)
      else
        throw error
      end
    end

    ## Lastly, create the VCluster CRD
    infrastructure_client = Kubeclient::Client.new(
      "#{@space.cluster.host}/apis/infrastructure.cluster.x-k8s.io", 'v1alpha1', auth_options: auth_options, ssl_options: ssl_options
    )

    # TODO: Point these to configurable setting somewhere
    @extra_args = {
      "oidc-issuer-url": "https://dev-61028818.okta.com/oauth2/default",
      "oidc-client-id": "0oa72w5ufijm6Xwso5d7",
      "oidc-username-prefix": "oidc:",
      "oidc-groups-prefix": "oidcgroup:",
      "oidc-username-claim": "preferred_username",
      "service-account-issuer": "https://oidc.#{@space.slug}.broken-smoke.launchboxhq.io",
      "service-account-jwks-uri": "https://oidc.#{@space.slug}.broken-smoke.launchboxhq.io/openid/v1/jwks",
      "service-account-signing-key-file": "/data/server/tls/service.key",
      "service-account-key-file": "/data/server/tls/service.key"
    }
    @users = ["oidc:robwittman@github.oktaidp"]
    @ingress = {
      enabled: true,
      class: "nginx"
    }
    #
    # puts ERB.new("./values.yaml.erb").result(binding)
    values = ERB.new(File.read("#{__dir__}/values.yaml.erb")).result(binding)

    vcluster = Kubeclient::Resource.new
    vcluster.kind = "VCluster"
    vcluster.metadata = {}
    vcluster.metadata.name = @space.slug
    vcluster.metadata.namespace = @space.slug
    vcluster.spec = {}
    vcluster.spec = {}
    vcluster.spec.kubernetesVersion = @space.cluster.version
    vcluster.spec.helmRelease = {
      "values": values
    }

    begin
      infrastructure_client.create_vcluster(vcluster)
    rescue Kubeclient::HttpError => error
      if error.error_code == 409
        infrastructure_client.merge_patch_vcluster(@space.slug, vcluster, @space.slug)
      else
        throw error
      end

    end

    puts "VCluster spun up in #{@space.slug} namespace. Give it a look"
    # Run some checks, and send notifications
  end
end
