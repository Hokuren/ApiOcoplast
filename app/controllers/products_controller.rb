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
    # puts "imprimiendo parametros"
    # puts quantity_product_params.inspect

    #binding.pry
    #if quantity_product_params.initial_date.nil? and quantity_product_params.last_date.nil?
    #  binding.pry
    #  cost =  Product.find(quantity_product_params.id).quantities.sum(:cost)
    #  weight =  Product.find(quantity_product_params.id).quantities.sum(:weight)
    # binding.pry
    #else
    #  binding.pry
    #  cost = Product.find(quantity_product_params.id).quantities.sum(:cost).where(created_at: (quantity_product_params.initial_date)..(quantity_product_params.last_date) )
    #  weight = Product.find(quantity_product_params.id).quantities.sum(:cost).where(created_at: (quantity_product_params.initial_date)..(quantity_product_params.last_date) ) 
    #  binding.pry
    #end
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
      params.require(:product).permit(:id, :initial_date, :last_date)
    end
end
