class HoldingSerializer < ActiveModel::Serializer
  attributes :id, :weight
  has_one :security
  has_one :portfolio
end
