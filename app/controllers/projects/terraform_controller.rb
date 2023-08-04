module Projects
  class TerraformController < AuthenticatedController
    before_action :state

    def index
      # Retrieve terraform state
      render status: :not_found if @state.nil?
      render json: @state.data if @state
    end

    def create
      # Store terraform state for a project
    end

    def lock
      # If locked, return a 409
      render json: @state.lock_data, status: :conflict if @state.lock_id

    end

    def unlock
      @lock_id = params[:ID]
    end

    private
    def state
      return @state if @state

      @state = @project.states.first
    end
  end
end
