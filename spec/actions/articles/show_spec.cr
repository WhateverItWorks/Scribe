require "../../spec_helper"

include ActionHelpers

describe Articles::Show do
  context "if the article is missing" do
    it "should raise a MissingPageError" do
      context = action_context(path: "/abc123")

      expect_raises(MissingPageError) do
        Articles::Show.new(context, params).call
      end
    end
  end
end
