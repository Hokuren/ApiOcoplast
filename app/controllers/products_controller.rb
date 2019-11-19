class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  def quantity
    quantity = quantity_product_params
 
    if quantity[:initial_date].nil? and quantity[:last_date].nil?   
    	Quantity.includes(:product).where("product_id = ?",quantity[:id]).group_by{ |x| x.product}.map{ |key,resource| [key.name,resource.map{ |q| q.cost}.reduce(:+).to_i,resource.map{ |q| q.weight}.reduce(:+).to_i]}
	else
        if Date.parse(quantity[:initial_date]) and Date.parse(quantity[:last_date])
			initial_date = Date.parse(quantity[:initial_date])
			last_date = Date.parse(quantity[:last_date])
			#cost = Product.find_by(id: quantity[:id]).quantities.where("created_at BETWEEN ? AND ?",initial_date,last_date).sum(:cost)
			#weight = Product.find_by(id: quantity[:id]).quantities.where("created_at BETWEEN ? AND ?",initial_date,last_date).sum(:weight)
			quantity = Quantity.includes(:product).where("product_id = ?",quantity[:id]).group_by{ |x| x.product }.map{ |key,resource| [key.name,resource.map{ |q| q.cost}.reduce(:+).to_i,resource.map{ |q| q.weight}.reduce(:+).to_i]}
			render json: quantity.inspect, status: :created, location: quantity
        else
          	render json: { message: "las fechas no son validas" }
        end 
    end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :cost, :weight)
    end

    def quantity_product_params
      { id:params[:id], initial_date:params[:initial_date], last_date:params[:last_date] }
    end
end

#ojo consulta
Quantity.includes(:product).where(product_id:[4]).group_by{|x| x.product}.map{|key,resource| [key.name,resource.map{|q| q.cost}.reduce(:+).to_i,resource.map{|q| q.weight}.reduce(:+).to_i]}
