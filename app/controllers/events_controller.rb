class EventsController < ApplicationController

  before_action :authenticate_user!, :except => [:index]

  before_action :set_event, :only => [:show, :edit, :update, :destroy]
  # GET /events/index
  # GET /events
  def index



    # if params["foo"]
    #   @events = Event.page(params[:page]).per(2)
    # elsif params["foo1"]
    #   @events = Event.page(params[:page]).per(3)
    # elsif
    # @events = Event.page( params[:page]).per(10)
    # end

    prepare_variable_for_index_template

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

  def latest
    @events = Event.order("id DESC").limit(3)
  end

  def show

    @page_title = @event.name
    respond_to do |format|
      format.html { @page_title = @event.name } # show.html.erb
      format.xml # show.xml.builder
      format.json { render :json => { id: @event.id, name: @event.name, created_at: @event.created_at }.to_json }    
    end
  end

  def dashboard
    @event = Event.find(params[:id])
  end

  def edit
    @events = Event.page(params[:page]).per(5)
    render :index
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    @event.user = current_user

    if @event.save
      flash[:notice] = "新增成功"
      redirect_to events_path
    else
      render :action => :new
    end
  end

  def update
    if params[:_remove_logo]=="1"
      @event.logo = nil
    end

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

    redirect_to events_path(:page => params[:page])

  end


  # POST /events/bulk_update

  def bulk_update
    ids = Array(params[:ids])
    events = ids.map{ |i| Event.find_by_id(i) }.compact

    if params[:commit] == "Publish"
      events.each{ |e| e.update( :status => "published" ) }
    elsif params[:commit] == "Delete"
      events.each{ |e| e.destroy }
    end

    redirect_to :back
  end


  # POST /events/bulk_delete
  #
  # def bulk_delete
  #   Event.destroy_all
  #
  #    redirect_to :back
  #  end

  #新的方法 要在routes.rb 加在resource之前（上到下讀取）
  # def first
  #   Event.first

  #   redirect_to events_path
  # end


  def join
    @event = Event.find(params[:id])
    Membership.find_or_create_by(:event => @event, :user => current_user)
    redirect_to :back
  end

  def withdraw
    @event = Event.find(params[:id])
    @membership = Membership.find_by(:event => @event, :user => current_user)
    @membership.destroy if @membership
    redirect_to :back
  end

  def subscribe
    @event = Event.find( params[:id] )

    subscription = @event.find_subscription_by(current_user)
    if subscription
      # do nothing
    else
      @subscription = @event.subscriptions.create!( :user => current_user )
    end

    redirect_to :back
  end
  def unsubscribe
    @event = Event.find( params[:id] )

    subscription = @event.find_subscription_by(current_user)
    subscription.destroy

    redirect_to :back
  end


  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name,:logo, :description,:category_id,:status,:location_attributes => [:id, :name, :_destroy],:group_ids => []  )
  end

  def prepare_variable_for_index_template

    @event = Event.new

    if params[:keyword]
      @events = Event.where( [ "name like ?", "%#{params[:keyword]}%" ] )
    else
      @events = Event.all
    end

    if params[:order]
      sort_by = (params[:order] == 'name') ? 'name' : 'id'
      @events = @events.order(sort_by)
    end

    @events = @events.page(params[:page]).per(5)

  end


end
