class PortfolioSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :holdings
end
