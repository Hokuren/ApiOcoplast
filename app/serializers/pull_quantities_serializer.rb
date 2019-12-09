class PullQuantitiesSerializer < ActiveModel::Serializer
attributes :id, :group_by_product ##, :phase, :product
##, :cost, :weight , :phase , :product


def group_by_product
    binding.pry
	products = Product.select("id").where(Product_id: self.object.product_id ).map{ |a| a.id }
    binding.pry
    lots = Lot.joins(:product_treatment_phases).where("phase_id = ? and product_id in ( ? )", self.object.phase_id, products).distinct
    binding.pry
    cost = lots.pluck(:cost).reduce(:+) 
    binding.pry
    weight = lots.pluck(:weight).reduce(:+) 
    binding.pry
    cost_weighted = ( cost / weight ) 

    return { product_id: self.object.product_id, cost: cost_weighted, weight: weight }
end


# def phase
# 	phase = ProductTreatmentPhase.where(lot_id: object.id).last.phase
# 	return {
# 			phase_id: phase.id,
# 			name: phase.name
# 	 	}
# end


# def product
# 	product = ProductTreatmentPhase.where(lot_id: object.id).last.product
# 	return { 
# 			id: product.id,
# 			name: product.name,
# 			product_id: product.product_id
# 			} 
# end

	
end
