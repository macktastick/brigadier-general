class Alert < ApplicationRecord

  belongs_to :post
  belongs_to :observation

end
