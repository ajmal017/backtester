class Holding < ActiveRecord::Base
  belongs_to :security
  belongs_to :portfolio
end
