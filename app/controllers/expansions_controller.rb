class ExpansionsController < ApplicationController
  before_action :set_expansion, only: [:show]

  def index
    @expansions = Expansion.all
  end

  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expansion
      @expansion = Expansion.find(params[:id])
    end
end
