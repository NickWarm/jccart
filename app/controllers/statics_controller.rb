class StaticsController < ApplicationController
  def index
    @items = @paginate = Item.paginate(:page => params[:page])
  end
end
