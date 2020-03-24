class ProductTreatmentPhaseClassificationSerializer < ActiveModel::Serializer

  attributes :id, :weight, :cost, :cost_treatments, :phase_id, :product_id #, :product_treatment_phases 
  
#   has_many :product_treatment_phases


#   def product_treatment_phases
# 	product_treatment_phase = ProductTreatmentPhase.find_by(id: self.object.id).product_treatment_phases
# 	product_treatment_phase.map do |p|
# 		ProductTreatmentPhaseClassificationSerializer.new(p,scope: scope,root: false)
# 		# {
# 		# cost: p.cost,
#         # weight: p.weight,
#         # phase_id: p.phase_id,
#         # product_treatment_phase_id: p.product_treatment_phase_id,
#         # lot_id: p.lot_id,
#         # product_id: p.product_id
#     	# } 
# 	  end
# 	  product_treatment_phase
# 	end

end

