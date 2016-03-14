class EventsController < ApplicationController

  before_action :set_event, :only => [:show, :edit, :update, :destroy]
  # GET /events/index
  # GET /events
  def index
    if params["foo"]
      @events = Event.page(params[:page]).per(2)
    elsif params["foo1"]
      @events = Event.page(params[:page]).per(3)
    elsif
      @events = Event.page( params[:page]).per(10)
    end


    #Rails.logger.debug("XXXXXXX:" + "#{@events.count}")

    respond_to do |format|
      format.html #index.html.erb
      format.xml {
        render :xml => @events.to_xml
      }
      format.json{
        render :json => @events.to_json
      }
      format.atom{
        @feed_title = "My event list"
      } #index.atom.builder
    end
  end

  def show

    @page_title = @event.name
    respond_to do |format|
      format.html { @page_title = @event.name } # show.html.erb
      format.xml # show.xml.builder
    format.json { render :json => { id: @event.id, name: @event.name, created_at: @event.created_at }.to_json }        end
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

  #新的方法 要在routes.rb 加在resource之前（上到下讀取）
  # def first
  #   Event.first

  #   redirect_to events_path
  # end


  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description)
  end

end
