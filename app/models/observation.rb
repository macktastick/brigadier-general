class Observation < ApplicationRecord

  belongs_to :post
  has_one :alert

end
