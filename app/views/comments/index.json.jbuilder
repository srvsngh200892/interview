json.count @comments.count 

json.comments (@comments) do |comment|
  json.id comment.id
  json.body comment.body
  json.created_at comment.created_at
  json.updated_at comment.updated_at
end
