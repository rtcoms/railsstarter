json.array!(@authentications) do |authentication|
  json.extract! authentication, :user_id, :provider, :index, :create, :destroy
  json.url authentication_url(authentication, format: :json)
end
