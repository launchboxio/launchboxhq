# frozen_string_literal: true

class StatusController < ApplicationController
  def health
    head :ok
  end

  def ready
    head :ok
  end
end
