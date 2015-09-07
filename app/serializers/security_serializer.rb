class SecuritySerializer < ActiveModel::Serializer
  attributes :id, :name, :ticker, :identifier
end
