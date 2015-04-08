class StatsController < ApplicationController
  def index
    @labels = Tag.pluck(:labels).flatten.
      group_by { |a| a }.
      map { |key, values| { tag: key, count: values.size } }

    render json: @labels
  end
end
