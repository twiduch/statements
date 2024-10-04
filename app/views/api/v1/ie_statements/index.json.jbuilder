json.array! @ie_statements do |ie_statement|
  json.id ie_statement.id
  json.name ie_statement.name
  json.created_at ie_statement.created_at.strftime('%Y-%m-%d %H:%M:%S')
end
