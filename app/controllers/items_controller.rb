class ItemsController < ApplicationController
  def index
    @items = @paginate = Item.paginate(:page => params[:page])
  end

  def show
    @item = Item.find(params[:id])
  end
end
