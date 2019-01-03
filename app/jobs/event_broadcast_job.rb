class EventBroadcastJob
  include SuckerPunch::Job

  def perform(event)
    broadcast_logger.info("Broadcasting Event: #{event}")
    ActionCable.server.broadcast 'activity_channel', message: render_event(event)
  end

  private

  def render_event(event)
    ApplicationController.renderer.render(partial: 'events/event', locals: { event: event })
  end

  def broadcast_logger
    @@broadcast_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end