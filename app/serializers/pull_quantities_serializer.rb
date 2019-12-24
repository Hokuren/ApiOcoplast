class PullQuantitiesSerializer < ActiveModel::Serializer

    attributes :product_name, :weight, :cost , :products

    #has_many :product_treatment_phases
    #ProductTreatmentPhase.joins(:lot).where(lots: {id: 69}).select("product_id","cost","weight").group_by

    def product_name
        product_treatment_phases = ProductTreatmentPhase.joins(:lot).where(lots: {id: object.id}).select("product_id","cost","weight")
        products = product_treatment_phases.map{|product_treatment_phase| product_treatment_phase.product_id }.uniq
        product = Product.where("id in ( ? )",products).select("product_id").distinct
        name =  Product.find_by(id: product.last.product_id).name

        return name
    end

    def products
        product_treatment_phases = ProductTreatmentPhase.joins(:lot).where(lots: {id: object.id}).select("product_id","cost","weight")
        products = product_treatment_phases.map{|product_treatment_phase| product_treatment_phase.product_id }.uniq
        product = Product.where("id in ( ? )",products).select("product_id").distinct
        name = Product.find_by(id: product.last.product_id).name
        inventary_product = []
        products.each do |product|
            cost_phase = 0
            cost = 0
            cost_total = 0
            weight = 0
            product_treatment_phases.each do |treatment_phase|
                if treatment_phase.product_id == product 
                    cost_phase = (treatment_phase.cost * treatment_phase.weight)
                    cost = cost + cost_phase
                    weight = weight + treatment_phase.weight

                end
            end
            cost_total = cost / weight
            product_name = Product.where(id: product).last
            inventary_product.push({ product_id: product,product_name: product_name.name, weight: weight , cost: cost_total})
        end

        return inventary_product
    end

























#attributes :product, :phase, :group_by_product

#def group_by_product
#
#    products = Product.select("id").where(Product_id: self.object.product_id ).map{ |a| a.id }
#    products = self.object.product_id if products.nil? || products.empty?
#    lots = Lot.joins(:product_treatment_phases).where("phase_id = ? and product_id in ( ? )", self.object.phase_id, products).distinct
#
#    l = lots.map{|l| l.id}
#    p = ProductTreatmentPhase.where("id in ( ? )",l)
#    products_inventary = p.pluck(:product_id).uniq
#
#    cost = lots.map{ |m| p = m.cost * m.weight}.reduce(:+).to_i 
#    weight = lots.pluck(:weight).reduce(:+) 
#   cost_weighted = ( cost / weight ) 
#    cost_weighted = 0.0 if cost_weighted.nil? || cost_weighted.nan? 
#    return { product_id: [products_inventary], cost: cost_weighted, weight: weight }
#
#end


#def phase
#	phase = ProductTreatmentPhase.where(lot_id: self.object.lot_id).last.phase
#	return {
#			phase_id: phase.id,
#			name: phase.name
#	 	}
#end


#def product
#	product = ProductTreatmentPhase.where(lot_id: self.object.lot_id).last.product
#	return { 
#			id: product.id,
#			name: product.name,
#			product_id: product.product_id
#		} 
#end



end
