class Dashboard::Admin::ItemsController < Dashboard::Admin::AdminController
  def index
    @items = @paginate = Item.paginate(:page => params[:page])
  end
end
