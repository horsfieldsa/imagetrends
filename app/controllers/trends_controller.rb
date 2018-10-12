class TrendsController < ApplicationController

  # GET /trends
  def index
    tag_logger.info("Loading trends view.")
  end

  def tag_logger
    @@tag_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end
