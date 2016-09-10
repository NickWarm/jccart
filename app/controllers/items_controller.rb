class ItemsController < ApplicationController

  def add_cart
    session[:cart] ||= {}
    item = Item.where(:id => params[:id]).first

    if item
      key = item.id.to_s
      session[:cart][key] ||= 0
      session[:cart][key] += 1
    end

    render :json => {:counter => session[:cart].length}.to_json
  end


  # GET /items
  def index
    @items = @paginate = Item .includes(:cate).paginate(:page => params[:page])
  end

  # GET /items/1
  def show
    @item = Item.find(params[:id])
  end

end
