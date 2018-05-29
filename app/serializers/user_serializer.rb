class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :admin,
      :slack_name
end
