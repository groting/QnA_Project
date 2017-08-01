class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id , :body, :created_at, :updated_at, :rating
  has_many :comments
  has_many :attachments
end
