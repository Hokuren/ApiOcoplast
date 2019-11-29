class PullQuantitiesSerializer < ActiveModel::Serializer
attributes :id, :cost, :weight , :phase , :product
		
def phase
	phase = ProductTreatmentPhase.where(lot_id: object.id).last.phase
	return {
			phase_id: phase.id,
			name: phase.name
			}
end

def product
	product = ProductTreatmentPhase.where(lot_id: object.id).last.product
	return { 
			product_id: product.id,
			name: product.name
			} 
end
	
end
