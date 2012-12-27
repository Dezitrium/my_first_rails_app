class EventsController < ApplicationController
  before_filter :find_user
  before_filter :get_view, only: [:week, :month]
  before_filter :get_recurring_types, only: [:new, :update, :edit, :create]

  def index
    @events = @user.events
    @view   = :list
  end

  def show
    @event = @user.events.find(params[:id])
    @dates = @event.event_data
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

  def today
    @events = @user.todays_events
    @view = :list
    render 'index'
  end

  def week
    date = Date.today.end_of_week
    cweek = (params[:cweek] || date.cweek).to_i
    year = (params[:year] || date.year).to_i

    @shown_week = Date.commercial(year, cweek)
    event_data = Event.dates_by_user(params[:user_id]).by_week(@shown_week)

    case @view
    when :list;     @events = event_data.map(&:event).uniq  # OPTIMIZE query      
    when :calendar; @calendar = WeekCalendar.new(@shown_week, event_data)      
    end

    render 'index'
  end

  def month
    month = (params[:month] || (Time.zone || Time).now.month).to_i
    year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.new(year, month)
    event_data = Event.dates_by_user(params[:user_id]).by_month(@shown_month)

    case @view
    when :list;     @events = event_data.map(&:event).uniq  # OPTIMIZE query
    when :calendar; @calendar = MonthCalendar.new(@shown_month, event_data)
    end

    render 'index'
  end

  private

    def find_user
      @user = User.find(params[:user_id])
    end

    def get_view
      @view = (params[:view] || 'list').to_sym
    end

    def get_recurring_types
      @recurring_types = Event::RECURRING_TYPES.map(&:to_s)
    end
end
