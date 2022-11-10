class SyncDeveloperSpaceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @space = Space.find(args.first)

    @options = {
      auth_options:  { bearer_token: @space.cluster.token },
      ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
    }

    begin
      create_namespace
      create_cluster
      create_vcluster
    rescue => error
      @space.update(status: "failed", last_error: error)
      raise error
    end

    @space.update(status: "provisioned", last_error: nil)
  end

  def create_namespace()
    client = Kubeclient::Client.new(@space.cluster.host, 'v1', **@options)

    begin
      client.create_namespace(Kubeclient::Resource.new({ metadata: { name: @space.slug } }))
    rescue Kubeclient::HttpError => error
      if error.error_code == 409
        # client.patch_namespace(@space.slug, {})
      else
        raise error
      end
    end
  end

  def create_cluster()
    cluster_client = Kubeclient::Client.new("#{@space.cluster.host}/apis/cluster.x-k8s.io", 'v1beta1', **@options)
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
        @space.update(status: "failed", last_error: error)
        raise error
      end
    end
  end

  def create_vcluster()
    infrastructure_client = Kubeclient::Client.new("#{@space.cluster.host}/apis/infrastructure.cluster.x-k8s.io", 'v1alpha1', **@options)

    # TODO: Point these to configurable setting somewhere
    @extra_args = {
      "oidc-issuer-url": ENV['OIDC_DOMAIN'] || "http://localhost:3000",
      "oidc-client-id": Doorkeeper::Application.find_by(name: "Kubernetes OIDC").uid,
      "oidc-username-prefix": "oidc:",
      "oidc-groups-prefix": "oidcgroup:",
      "oidc-username-claim": "email",
      "service-account-issuer": "https://oidc.#{@space.slug}.broken-smoke.launchboxhq.io",
      "service-account-jwks-uri": "https://oidc.#{@space.slug}.broken-smoke.launchboxhq.io/openid/v1/jwks",
      "service-account-signing-key-file": "/data/server/tls/service.key",
      "service-account-key-file": "/data/server/tls/service.key"
    }
    @users = ["oidc:robkwittman@gmail.com"]
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
    vcluster.spec.helmRelease = {}
    vcluster.spec.helmRelease.values = values

    begin
      infrastructure_client.create_vcluster(vcluster)
    rescue Kubeclient::HttpError => error
      if error.error_code == 409
        infrastructure_client.merge_patch_vcluster(@space.slug, vcluster, @space.slug)
      else
        @space.update(status: "failed", last_error: error)
        raise error
      end
    end
  end
end
