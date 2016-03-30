class UbikesController < ApplicationController
  def ubikes_data
    @ubikes = Ubike.all
  end
end
