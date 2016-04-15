class ApiV1::EventsController < ApiController

  def index
    render :json => { :message => "Test"}
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
