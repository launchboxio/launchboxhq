
class AgentsController < Gruf::Controllers::Base
  bind ::Launchbox::Jobs::Service

  ##
  # @return [Demo::GetJobResp] The job response
  #
  def get_job
    job = ::Job.find(request.message.id)
    Demo::GetJobResp.new(id: job.id)
  rescue ActiveRecord::RecordNotFound => _e
    fail!(:not_found, :job_not_found, "Failed to find Job with ID: #{request.message.id}")
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end
end