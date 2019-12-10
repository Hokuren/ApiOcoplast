class PullQuantitiesSerializer < ActiveModel::Serializer
attributes :product, :phase, :group_by_product


def group_by_product

    products = Product.select("id").where(Product_id: self.object.product_id ).map{ |a| a.id }
    products = self.object.product_id if products.nil? || products.empty?
    lots = Lot.joins(:product_treatment_phases).where("phase_id = ? and product_id in ( ? )", self.object.phase_id, products).distinct

    l = lots.map{|l| l.id}
    p = ProductTreatmentPhase.where("id in ( ? )",l)
    products_inventary = p.pluck(:product_id).uniq

    cost = lots.map{ |m| p = m.cost * m.weight}.reduce(:+).to_i 
    weight = lots.pluck(:weight).reduce(:+) 
    cost_weighted = ( cost / weight ) 
    cost_weighted = 0.0 if cost_weighted.nil? || cost_weighted.nan? 
    return { product_id: [products_inventary], cost: cost_weighted, weight: weight }

end


def phase
	phase = ProductTreatmentPhase.where(lot_id: self.object.lot_id).last.phase
	return {
			phase_id: phase.id,
			name: phase.name
	 	}
end


def product
	product = ProductTreatmentPhase.where(lot_id: self.object.lot_id).last.product
	return { 
			id: product.id,
			name: product.name,
			product_id: product.product_id
		} 
end



end
