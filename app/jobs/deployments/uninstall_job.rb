module Deployments
  class UninstallJob
    include Sidekiq::Job

    def perform(*args)
      # Do something later
      @deployment = ResourceDeployment.find(args.first)
      @project = @deployment.project
      @cluster = @project.cluster

      client = @cluster.get_client("", "v1")
      secret = client.get_secret "vc-#{@project.slug}", @project.slug

      t = Tempfile.new(@project.slug)
      t.write(Base64.decode64(secret.data.config))
      t.rewind

      hclient = Rhelm::Client.new(kubeconfig: t.path)
      hclient.uninstall(@deployment.name, namespace: 'default').run do |lines, status|
        puts lines
        if status == 0
          logger.info("helm uninstall worked great!")
          t.close
        elsif /timeout/im.match(lines)
          t.close
          raise MyTimeoutError, "helm uninstall timed out, oh no!"
        else
          # Use the built-in error reporting code to get more details
          t.close
          report_failure(lines, status)
        end
      end

      @deployment.destroy!
    end
  end
end
