require "rails_helper"

describe "Tags" do
  describe "POST /tags" do
    context "when a tag doesn't already exist" do
      it "creates a tag" do
        entity_id = 123
        entity_type = "Article"
        labels = ["red", "white", "blue"]
        post(
          "/tags",
          tag: {
            taggable_id: entity_id,
            taggable_type: entity_type,
            labels: labels
          }
        )

        tag_attributes = JSON.parse(response.body)["tag"].except("id")
        expect(response.status).to eq 201
        expect(tag_attributes).to eq(
          "taggable_id" => entity_id,
          "taggable_type" => entity_type,
          "labels" => labels
        )
      end
    end
  end
end
