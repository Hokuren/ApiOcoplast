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
	
	begin 
		if quantity[:initial_date].nil? and quantity[:last_date].nil?   
			quantities = Quantity.includes(:product).where("product_id = ?",quantity[:id]).group_by{ |x| x.product}.map{ |key,resource| [key.name,resource.map{ |q| q.cost}.reduce(:+).to_i,resource.map{ |q| q.weight}.reduce(:+).to_i]}
		else
			if Date.parse(quantity[:initial_date]) and Date.parse(quantity[:last_date])
				initial_date = DateTime.parse(quantity[:initial_date] + ' 00:00:00')
				last_date = DateTime.parse(quantity[:last_date] + ' 23:59:59')
				quantities = Quantity.includes(:product).where("product_id = ? and created_at between ? and ?",quantity[:id],initial_date,last_date).group_by{ |x| x.product }.map{ |key,resource| [key.id,key.name,resource.map{ |q| q.cost}.reduce(:+).to_i,resource.map{ |q| q.weight_initial }.reduce(:+).to_i]}
				if !quantities.nil?
					render json: { product_id: quantities[0][0], name: quantities[0][1], cost: quantities[0][2], weight: quantities[0][3] }
				end
			else
				render json: { message: "las fechas no son validas" }
			end 
		end 
	rescue
		render json: { message: "No hay resgistros" }
	end
end


#phase_quantities
def quantity_phase  
  quantity_phase = quantity_phase_lot_params
  
	unless quantity_phase[:id].nil? and quantity_phase[:product_id].nil?
		if !quantity_phase[:id].nil? and quantity_phase[:product_id].nil?
			begin
				#lot_phase = ProductTreatmentPhase.where(phase_id: quantity_phase[:id])
				lot_phase = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { phase_id: quantity_phase[:id] }).distinct
				render json: lot_phase , each_serializer: PhaseQuantitiesSerializer
			rescue
				render json: { message: "no existe un inventario de esa face" }
			end
		elsif !quantity_phase[:id].nil? and !quantity_phase[:product_id].nil?
			begin
				#lot_phase = ProductTreatmentPhase.joins(lot: [:quantities]).where(phase_id: quantity_phase[:id], quantities: { product_id: quantity_phase[:product_id]}).last
				lot_phase = Lot.joins(:product_treatment_phases, :quantities).where( product_treatment_phases: { phase_id: quantity_phase[:id] } , quantities:{ product_id: quantity_phase[:product_id] }).last
				render json: lot_phase , serializer: PhaseQuantitiesSerializer
			rescue
				render json: { message: "no existe un invetario de ese producto en la fase" }
			end	
		elsif quantity_phase[:id].nil? and !quantity_phase[:product_id].nil?
			begin
				lot_phase = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { product_id: quantity_phase[:product_id] }).distinct
				render json: lot_phase , each_serializer: PhaseQuantitiesSerializer
			rescue
				render json: { message: "no existe un invetario de ese producto" }
			end	
		end
    
	else 
		render json: { message: "no enviaste parametros" }	
	end
end


#pull_quantities
def quantity_pull

    begin  
        lot_phase = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { phase_id: 3 }).distinct
        render json: lot_phase , each_serializer: PullQuantitiesSerializer
    rescue  
        render json: { message: "no existe un inventario de esa face" }    
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

    def quantity_phase_lot_params
      { id:params[:phase_id] , product_id:params[:product_id] }
    end
end

