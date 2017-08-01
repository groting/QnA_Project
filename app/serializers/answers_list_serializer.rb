class AnswersListSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :rating
  has_many :comments
end
