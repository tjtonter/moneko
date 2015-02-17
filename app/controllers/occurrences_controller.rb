class OccurrencesController < ApplicationController
  def index
    @occurrences = Occurrence.where("start < ? AND end > ?", params[:end], params[:start])
    respond_to do |format|
      format.html
      format.json { render json: @occurrences.as_json }
    end
  end
end
