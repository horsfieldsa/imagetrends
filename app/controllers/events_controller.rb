class EventsController < ApplicationController
  def index
    @events = Event.all.order(created_at: :desc).paginate(page: params[:page])
  end
end
