# frozen_string_literal: true

module Projects
  class CreateProjectJob < ApplicationJob
    queue_as :default

    def perform(*args)
      project = Project.find(args.first)

      puts project.cluster.token
      @options = {
        auth_options: { bearer_token: project.cluster.token },
        # TODO: Use the provided CA certificate, if supplied
        ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
      }

      puts @options

      case project.cluster.connection_type
      when "agent"
        puts "Here, we'd do something over GRPC?"
      when "service_account"
        begin
          create_namespace
          create_cluster
          create_vcluster
        rescue StandardError => e
          project.update(status: 'failed', last_error: e)
          raise e
        end
      else
        puts "Invalid cluster connection_type found, exiting"
      end

      project.update(status: 'provisioned', last_error: nil)
    end

    def create_namespace
      client = Kubeclient::Client.new(project.cluster.host, 'v1', **@options)

      begin
        client.create_namespace(Kubeclient::Resource.new({ metadata: { name: project.slug } }))
      rescue Kubeclient::HttpError => e
        raise e unless e.error_code == 409
        # client.patch_namespace(project.slug, {})
      end
    end

    def create_cluster
      cluster_client = Kubeclient::Client.new("#{project.cluster.host}/apis/cluster.x-k8s.io", 'v1beta1', **@options)
      cluster_client.discover

      cluster = Kubeclient::Resource.new
      cluster.kind = 'Cluster'
      cluster.metadata = {}
      cluster.metadata.name = project.slug
      cluster.metadata.namespace = project.slug
      cluster.spec = {}
      cluster.spec.controlPlaneRef = {}
      cluster.spec.controlPlaneRef.apiVersion = 'infrastructure.cluster.x-k8s.io/v1alpha1'
      cluster.spec.controlPlaneRef.kind = 'VCluster'
      cluster.spec.controlPlaneRef.name = project.slug

      cluster.spec.infrastructureRef = {}
      cluster.spec.infrastructureRef.apiVersion = 'infrastructure.cluster.x-k8s.io/v1alpha1'
      cluster.spec.infrastructureRef.kind = 'VCluster'
      cluster.spec.infrastructureRef.name = project.slug

      begin
        cluster_client.create_cluster(cluster)
      rescue Kubeclient::HttpError => e
        if e.error_code == 409
          cluster_client.merge_patch_cluster(project.slug, cluster, project.slug)
        else
          project.update(status: 'failed', last_error: e)
          raise e
        end
      end
    end

    def create_vcluster
      infrastructure_client = Kubeclient::Client.new("#{project.cluster.host}/apis/infrastructure.cluster.x-k8s.io",
                                                     'v1alpha1', **@options)

      # TODO: Point these to configurable setting somewhere
      @extra_args = {
        'oidc-issuer-url': ENV['OIDC_DOMAIN'] || 'http://localhost:3000',
        'oidc-client-id': Doorkeeper::Application.find_by(name: 'Kubernetes OIDC').uid,
        'oidc-username-prefix': 'oidc:',
        'oidc-groups-prefix': 'oidcgroup:',
        'oidc-username-claim': 'email',
        'service-account-issuer': "https://oidc.#{project.slug}.broken-smoke.launchboxhq.io",
        'service-account-jwks-uri': "https://oidc.#{project.slug}.broken-smoke.launchboxhq.io/openid/v1/jwks",
        'service-account-signing-key-file': '/data/server/tls/service.key',
        'service-account-key-file': '/data/server/tls/service.key'
      }
      @users = ['oidc:robkwittman@gmail.com']
      @ingress = {
        enabled: true,
        class: 'nginx'
      }
      #
      # puts ERB.new("./values.yaml.erb").result(binding)
      values = ERB.new(File.read("#{__dir__}/values.yaml.erb")).result(binding)

      vcluster = Kubeclient::Resource.new
      vcluster.kind = 'VCluster'
      vcluster.metadata = {}
      vcluster.metadata.name = project.slug
      vcluster.metadata.namespace = project.slug
      vcluster.spec = {}
      vcluster.spec = {}
      vcluster.spec.kubernetesVersion = project.cluster.version
      vcluster.spec.helmRelease = {}
      vcluster.spec.helmRelease.values = values

      begin
        infrastructure_client.create_vcluster(vcluster)
      rescue Kubeclient::HttpError => e
        if e.error_code == 409
          infrastructure_client.merge_patch_vcluster(project.slug, vcluster, project.slug)
        else
          project.update(status: 'failed', last_error: e)
          raise e
        end
      end
    end
  end
end