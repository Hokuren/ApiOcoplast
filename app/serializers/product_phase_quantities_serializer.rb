class ProductPhaseQuantitiesSerializer < ActiveModel::Serializer

attributes :products #, :phases

def products
  product = ProductTreatmentPhase.where(lot_id: object.id).last.product
  lots = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { product_id: product.id }) 
  product_phases = []
  variable_phase_id = @instance_options[:Variable_phase_id]
  lots.each do |lot|
    #phase = ProductTreatmentPhase.where(lot_id: lot.id).last.phase
    phase = ProductTreatmentPhase.where(lot_id: lot.id).last.phase
    if( !variable_phase_id.blank? || !variable_phase_id.nil? )
      if (variable_phase_id === phase.id)
        product_phases.push(phase_id: phase.id,phase_name: phase.name,cost: lot.cost,weight: lot.weight)
      end 
    else 
      product_phases.push(phase_id: phase.id,phase_name: phase.name,cost: lot.cost,weight: lot.weight)
    end
  end 
	return {
    product_id: product.product_id,
    product_name: product.name,	
    phases: product_phases
  }  
  
end


# def phases()
#   product = ProductTreatmentPhase.where(lot_id: object.id).last.product
#   lots = Lot.joins(:product_treatment_phases).where(product_treatment_phases: { product_id: product.id }) 
#   product_phases = []
#   lots.each do |lot|
#     phase = ProductTreatmentPhase.where(lot_id: lot.id).last.phase
#     product_phases.push(phase_id: phase.id,phase_name: phase.name,cost: lot.cost,weight: lot.weight)
#   end 
#   return product_phases
# end 

end
