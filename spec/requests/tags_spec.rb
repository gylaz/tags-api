require "rails_helper"

describe "Tags" do
  describe "POST /tags" do
    context "when a tag doesn't already exist" do
      it "creates a tag" do
        post "/tags", request_params

        tag_attributes = JSON.parse(response.body)["tag"].except("id")
        expect(response.status).to eq 201
        expect(Tag.count).to eq 1
        expect(tag_attributes).to eq(
          "taggable_id" => request_params[:tag][:taggable_id],
          "taggable_type" => request_params[:tag][:taggable_type],
          "labels" => request_params[:tag][:labels],
        )
      end
    end

    context "when a tag for an entity already exist" do
      it "updates the entity" do
        new_labels = ["sf", "la"]
        Tag.create!(
          taggable_id: request_params[:tag][:taggable_id],
          taggable_type: request_params[:tag][:taggable_type],
          labels: ["one", "two"],
        )

        post "/tags", request_params(labels: new_labels)

        tag_attributes = Tag.first.slice(:taggable_id, :taggable_type, :labels)
        expect(Tag.count).to eq 1
        expect(tag_attributes).to eq(
          "taggable_id" => request_params[:tag][:taggable_id],
          "taggable_type" => request_params[:tag][:taggable_type],
          "labels" => new_labels,
        )
      end
    end
  end

  def request_params(attributes = {})
    {
      tag: {
        taggable_id: attributes.fetch(:taggable_id, 123),
        taggable_type: attributes.fetch(:taggable_type, "Article"),
        labels: attributes.fetch(:labels, ["red", "white", "blue"]),
      }
    }
  end
end
