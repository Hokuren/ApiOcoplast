class Quantity < ApplicationRecord

  belongs_to :product
  belongs_to :lot

  before_update :created_quantity_intial 
  after_commit  :created_quantity_intial
  
  private 
  
  def created_quantity_intial
    audit = AuditQuantity.new(cost: self.cost, weight: self.weight, weight_initial: self.weight_initial,
                              date: self.date, product_id: self.product_id, lot_id: self.lot_id, quantity_id: self.id) 
    audit.save 
  end 
 


end
