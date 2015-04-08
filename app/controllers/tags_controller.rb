class TagsController < ApplicationController
  def create
    @tag = Tag.where(tag_params[:entity_id], tag_params[:entity_type]).
      first_or_initialize(tag_params)
    @tag.labels = tag_params[:labels]

    if @tag.save
      render json: @tag, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  private

  def tag_params
    params.require(:tag).permit(
      :taggable_id,
      :taggable_type,
      labels: [],
    )
  end
end
