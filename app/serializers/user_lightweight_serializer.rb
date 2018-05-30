class UserLightweightSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :slack_name
end
