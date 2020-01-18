class CostsPhaseSerializer < ActiveModel::Serializer
  attributes :id, :type_cost, :porcentage, :cost_id, :phase_id, :cost_name, :cost 

  def cost_name
    cost_name = Cost.find_by(id: object.cost_id)
    
    return cost_name.name
  end

  def cost
    cost = Cost.find_by(id: object.cost_id)
    
    return cost.cost
  end


end