json.extract! keystore, :id, :url, :user_id, :created_at, :updated_at
json.url keystore_url(keystore, format: :json)