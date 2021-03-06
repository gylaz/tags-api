require "rails_helper"

describe "Tags" do
  describe "POST /tags" do
    context "when a tag doesn't already exist" do
      it "creates a tag" do
        post "/tags", request_params

        tag_attributes = JSON.parse(response.body).except("id")
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
        create_tag

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

  describe "GET /tags/:taggable_type/:taggable_id" do
    it "returns entity info with tags" do
      tag = create_tag

      get "/tags/#{tag.taggable_type}/#{tag.taggable_id}"

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)).to eq({
        "id" => tag.taggable_id,
        "type" => tag.taggable_type,
        "labels" => tag.labels,
      })
    end
  end

  describe "DELETE /tags/:taggable_type/:taggable_id" do
    it "deletes the entry" do
      tag = create_tag

      delete "/tags/#{tag.taggable_type}/#{tag.taggable_id}"

      expect(response.status).to eq 204
      expect(response.body).to eq ""
      expect(Tag.count).to eq 0
    end
  end

  describe "GET /stats" do
    it "returns stats of tag usage" do
      tag1 = create_tag(taggable_id: 1, taggable_type: "Article", labels: ["ca", "co"])
      tag2 = create_tag(taggable_id: 2, taggable_type: "Article", labels: ["ca", "ny"])
      tag3 = create_tag(taggable_id: 2, taggable_type: "Product", labels: ["or", "ca", "co"])

      get "/stats"

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)).to match_array([
        { "tag" => "ca", "count" => 3 },
        { "tag" => "co", "count" => 2 },
        { "tag" => "or", "count" => 1 },
        { "tag" => "ny", "count" => 1 },
      ])
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

  def create_tag(attributes = {})
    Tag.create!(
      taggable_id: attributes.fetch(:taggable_id, request_params[:tag][:taggable_id]),
      taggable_type: attributes.fetch(:taggable_type, request_params[:tag][:taggable_type]),
      labels: attributes.fetch(:labels, ["la", "sf"]),
    )
  end
end
