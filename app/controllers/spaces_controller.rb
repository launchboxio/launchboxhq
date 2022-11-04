class SpacesController < AuthenticatedController
  include ActionController::Live

  def index
    @spaces = Space.all
  end

  def show
  end

  def new
    @clusters = Cluster.all
    @addons = Addon.all
    @space = Space.new
  end

  def create
    @space = Space.new(space_params)
    @space.cluster = Cluster.find(params[:space][:cluster])
    @space.user = current_user

    if @space.save
      SyncDeveloperSpaceJob.perform_now(@space.id)
      redirect_to @space
    else
      @clusters = Cluster.all
      render "new"
    end
  end

  def update

  end

  def delete
    @space = Space.find(params[:id])
    @space.destroy
    CleanupUserSpaceJob.perform_now(@space.slug, @space.cluster_id)
  end

  def restart

  end

  def logs
    response.headers['Content-Type'] = 'text/event-stream'

    # hack due to new version of rack not supporting sse and sending all response at once: https://github.com/rack/rack/issues/1619#issuecomment-848460528
    response.headers['Last-Modified'] = Time.now.httpdate
    @space = Space.find(params[:id])
    auth_options = {
      bearer_token: @space.cluster.token
    }
    ssl_options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
    client = Kubeclient::Client.new(
      @space.cluster.host, 'v1', auth_options: auth_options, ssl_options: ssl_options
    )
    # TODO: We want to stream at some point
    # client.watch_pod_log("#{@space.slug}-0", @space.slug, container: 'vcluster') do |line|
    #   response.stream.write line
    # end
    # response.stream.close
    # puts "Route ended"
    render plain: client.get_pod_log("#{@space.slug}-0", @space.slug, container: 'vcluster')
  end

  private

  def space_params
    params.require(:space).permit(:name)
  end
end
