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
      
      @product.update(product_id: @product.id) if @product.product_id.nil? 
      
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
            return render json: { message: "las fechas no son validas" } unless Date.parse(quantity[:initial_date]) and Date.parse(quantity[:last_date])
            
            initial_date = DateTime.parse(quantity[:initial_date] + ' 00:00:00')
            last_date = DateTime.parse(quantity[:last_date] + ' 23:59:59')
            quantities = Quantity.includes(:product).where("product_id = ? and date between ? and ?",quantity[:id],initial_date,last_date).group_by{ |x| x.product }.map{ |key,resource| [key.id,key.name,resource.map{ |q| q.cost}.reduce(:+).to_i,resource.map{ |q| q.weight_initial }.reduce(:+).to_i]}
            
            if quantities.nil? 
                render json: { message: "No hay resgistros" }
            else 
                render json: { product_id: quantities[0][0], name: quantities[0][1], cost: quantities[0][2], weight: quantities[0][3] } 
            end
        end 
    rescue
        render json: { message: "No hay resgistros" }
    end
  end


  def quantity_detail 
    quantity = quantity_product_params	
    begin 
        if quantity[:initial_date].nil? and quantity[:last_date].nil?   
            quantities = Quantity.includes(:product).where("product_id = ?",quantity[:id])
        else
            return render json: { message: "las fechas no son validas" } unless Date.parse(quantity[:initial_date]) and Date.parse(quantity[:last_date])
            
            initial_date = DateTime.parse(quantity[:initial_date] + ' 00:00:00')
            last_date = DateTime.parse(quantity[:last_date] + ' 23:59:59')
            quantities = Quantity.includes(:product).where("product_id = ? and date between ? and ?",quantity[:id],initial_date,last_date)
            
            if quantities.nil? 
                render json: { message: "No hay resgistros" }
            else 
                render json: quantities
            end
        end 
    rescue
        render json: { message: "No hay resgistros" }
    end
  end


#phase_quantities
def quantity_phase  
    quantity_phase = quantity_phase_lot_params
  
    message = "no enviaste parametros"		
    lot_phase = nil
    if !quantity_phase[:id].nil? and quantity_phase[:product_id].nil?
        lot_phase = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { phase_id: quantity_phase[:id] }).distinct   
        
        message = "no existe un inventario de esa face" if lot_phase.nil?
        
        if lot_phase.nil? then render json: { message: message } else render json: lot_phase,Variable_phase_id: quantity_phase[:id], each_serializer: ProductPhaseQuantitiesSerializer end 
          
    elsif !quantity_phase[:id].nil? and !quantity_phase[:product_id].nil?
        lot_phase = Lot.joins(:product_treatment_phases, :quantities).where( product_treatment_phases: { phase_id: quantity_phase[:id] } , quantities:{ product_id: quantity_phase[:product_id] }).last
    
        message = "no existe un invetario de ese producto en la fase" if lot_phase.nil?

        if lot_phase.nil? then render json: { message: message } else render json: lot_phase ,Variable_phase_id: quantity_phase[:id], serializer: ProductPhaseQuantitiesSerializer end 

    elsif quantity_phase[:id].nil? and !quantity_phase[:product_id].nil?
        lot_phase = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { product_id: quantity_phase[:product_id] }).distinct.last
        
        message = "no existe un invetario de ese producto" if lot_phase.nil?

        if lot_phase.nil? then render json: { message: message } else render json: lot_phase , serializer: ProductPhaseQuantitiesSerializer end 

    elsif quantity_phase[:id].nil? and quantity_phase[:product_id].nil?
        lot_phases = Lot.joins(:product_treatment_phases).distinct
        products = []
        lots = []
        lot_phases.each do |lot|
          product_treatment_phase = ProductTreatmentPhase.joins(:lot).where(lot_id: lot.id).last
          unless (products.include?(product_treatment_phase.product_id))
            lots.push(product_treatment_phase.lot_id)
          end
          products.push(product_treatment_phase.product_id)
        end 
        lot_phase = Lot.where("id in ( ? )",lots)
        message = "No existe un inventario" if lot_phase.nil?

        if lot_phase.nil? then render json: { message: message } else render json: lot_phase , each_serializer: ProductPhaseQuantitiesSerializer end 

    end

    

end

#pull_quantities
#def quantity_pull
#
#    begin  
#        phase_id = params[:phase_id] 
#        products = Product.distinct
#        phases = []
#        product_id = []
#        product = []
#        products.each do |p|
#
#            phase = ProductTreatmentPhase.joins(:lot).where("phase_id = ? and product_id in ( ? )",phase_id,p.id).distinct.last
#            pro = products.where(id: p.id).last
#    
#            if product.include?(pro.id) || product.include?(pro.product_id)
#                phases 
#            else 
#                unless phase.nil?
#                    phases << phase 
#                    product << phase.product_id
#                end
#            end 
#        end
#        render json: phases , each_serializer: PullQuantitiesSerializer
#    rescue  
#        render json: { message: "No existe un inventario en la Phase" }    
#    end  
#    
#end


#pull_quantities
def quantity_pull


begin  

  lots =  Lot.joins(:product_treatment_phases).where("phase_id = 5").uniq
  
  render json: lots , each_serializer: PullQuantitiesSerializer
rescue  
  #        render json: { message: "No existe un inventario en la Phase" }    
 end  
   
end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :cost, :weight, :product_id)
    end

    def quantity_product_params
      { id:params[:id], initial_date:params[:initial_date], last_date:params[:last_date] }
    end

    def quantity_phase_lot_params
      { id:params[:phase_id] , product_id:params[:product_id] }
    end
    
end

