class HoldingSerializer < ActiveModel::Serializer
  attributes :id, :weight
  has_one :security
  # shas_one :portfolio
end
