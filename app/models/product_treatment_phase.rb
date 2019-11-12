class ProductTreatmentPhase < ApplicationRecord
  belongs_to :phase
  has_many :product_treatment_phases
  has_many :lots
  has_many :product_treatments

  
  #before_create :set_lot

  #private

  #def set_lot
 
  #  if !@product_treatment_phase.product_treatment_phase_id.nil?
  #    @lot = ProductTreatmentPhase.find(2).lots
  #    total_cost = @lot.quantities.sum(:cost) - @product_treatment_phase.cost
  #   total_weight = @lot.quantities.sum(:weight) - @product_treatment_phase.weight
  #      if @product_treatment_phase.weight > total_weight
  #        ProductTreatmentPhase.find(@product_treatment_phase.product_treatment_phase_id).lots.update(cost: total_cost, weight: total_weight)
  #  end 
  #end 




end
