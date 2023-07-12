require "./medium_client"

# This allows you to read posts responses from a local file instead of hitting # the API all the time. You can get an api response by inserting the post id
# in this curl(1) command:

# curl -X "POST" "https://medium.com/_/graphql" \
#      -H 'Content-Type: application/json; charset=utf-8' \
#      -d $'{
# 	"query": "query{post(id:\\"[post id here]\\"){title creator{name id}content{bodyModel{paragraphs{text type markups{name title type href start end rel anchorType}href iframe{mediaResource{id}}layout metadata{__typename id originalWidth originalHeight}}}}}}"
# }' > [post id here].json

# Then place it in the /tmp/posts directory. The post id will come in as a
# query param and go look for a file with a matching filename.

class LocalClient < MediumClient
  def self.post_data(post_id : String) : PostResponse::Root
    body = File.read("tmp/posts/#{post_id}.json")
    PostResponse::Root.from_json(body)
  end
end
