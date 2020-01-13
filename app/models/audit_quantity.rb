class AuditQuantity < ApplicationRecord
  belongs_to :product
  belongs_to :lot
  belongs_to :quantity
end
