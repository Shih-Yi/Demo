class ApiV1::EventsController < ApiController

  def index
    @events = Event.page( params[:page] )
  end

  def show
    @event = Event.find(params[:id])
    # show.json.jbuilder
  end

  def create
    @event = Event.new( :name => params[:name],
                       :description => params[:description] )

    if @event.save
      render :json => { :id => @event.id }
    else
      render :json => { :message => "failed", :errors => @event.errors }, :status => 400
    end
  end

end
