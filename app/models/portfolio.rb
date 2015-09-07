class Portfolio < ActiveRecord::Base
  has_many  :holdings
end
