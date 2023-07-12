class Page
  getter nodes : Nodes::Children
  getter title : String
  getter author : PostResponse::Creator
  getter created_at : Time

  def initialize(
    @title : String,
    @author : PostResponse::Creator,
    @created_at : Time,
    @nodes : Nodes::Children = [] of Nodes::Child
  )
  end
end
