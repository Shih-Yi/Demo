class EventsController < ApplicationController

  before_action :set_event, :only => [:show, :edit, :update, :destroy]
  # GET /events/index
  # GET /events
  def index
    @events = Event.page( params[:page] ).per(10)
  end

  def show
  
    @page_title = @event.name 
  end

  def edit
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(event_params)
  
    if @event.save
      flash[:notice] = "新增成功"
      redirect_to events_path
    else
      render :action => :new
    end
  end
  
  def update
    if @event.update(event_params)

      flash[:notice] = "update 成功"

      redirect_to event_path(@event)
    else
     render :action => :edit
    end 
  end

  def destroy
    @event.destroy

    flash[:alert] = "delete成功"

    redirect_to events_path    

  end


  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description)
  end

end
