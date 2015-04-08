class TagsController < ApplicationController
  def show
    @tag = Tag.where(
      taggable_id: params[:taggable_id],
      taggable_type: params[:taggable_type],
    ).first

    render json: @tag, serializer: EntitySerializer
  end

  def create
    @tag = Tag.where(
      taggable_id: tag_params[:taggable_id],
      taggable_type: tag_params[:taggable_type],
    ).first_or_initialize
    @tag.labels = tag_params[:labels]

    if @tag.save
      render json: @tag, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    tag = Tag.where(
      taggable_id: params[:taggable_id],
      taggable_type: params[:taggable_type],
    ).first
    tag.destroy

    render json: :none, status: :no_content
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
