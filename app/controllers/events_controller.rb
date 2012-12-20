class EventsController < ApplicationController
  before_filter :find_user

  def index
    @events = @user.events
    @cal = WeekCalendar.new(12, 2012)    
  end

  def show
    @event = @user.events.find(params[:id])
  end

  def new
    @event = @user.events.build
  end

  def edit
    @event = @user.events.find(params[:id])
  end

  def create
    @event = @user.events.build(params[:event])

    if @event.save
      redirect_to [@user, @event], notice: 'Event was successfully created.'
    else
      render 'new'
    end
  end

  def update
    @event = @user.events.find(params[:id])

    if @event.update_attributes(params[:event])
      redirect_to [@user, @event], notice: 'Event was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @event = @user.events.find(params[:id])
    @event.destroy

    redirect_to user_events_path(@user)
  end

  private

    def find_user
      @user = User.find(params[:user_id])
    end
end