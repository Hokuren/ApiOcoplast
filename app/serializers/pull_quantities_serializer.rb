class PullQuantitiesSerializer < ActiveModel::Serializer
  attributes :id, :cost, :weight,:phase

#def product
#	product = Product.joins(:quantities).where(quantities: { lot_id: object.id }).last
#	return { 
#			product_id: product.id,
#			name: product.name
#			} 
#end

def phase
	phase = ProductTreatmentPhase.where(lot_id: object.id).last.phase
	return {
			phase_id: phase.id,
			name: phase.name
	 	}
end

end
