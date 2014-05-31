json.array!(@crushes) do |crush|
  json.extract! crush, :id
  json.url crush_url(crush, format: :json)
end
