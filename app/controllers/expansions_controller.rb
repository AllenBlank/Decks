class ExpansionsController < ApplicationController
  before_action :set_expansion, only: [:show, :edit, :update, :destroy]

  # GET /expansions
  # GET /expansions.json
  def index
    @expansions = Expansion.all
  end

  # GET /expansions/1
  # GET /expansions/1.json
  def show
  end

  # GET /expansions/new
  def new
    @expansion = Expansion.new
  end

  # GET /expansions/1/edit
  def edit
  end

  # POST /expansions
  # POST /expansions.json
  def create
    @expansion = Expansion.new(expansion_params)

    respond_to do |format|
      if @expansion.save
        format.html { redirect_to @expansion, notice: 'Expansion was successfully created.' }
        format.json { render :show, status: :created, location: @expansion }
      else
        format.html { render :new }
        format.json { render json: @expansion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expansions/1
  # PATCH/PUT /expansions/1.json
  def update
    respond_to do |format|
      if @expansion.update(expansion_params)
        format.html { redirect_to @expansion, notice: 'Expansion was successfully updated.' }
        format.json { render :show, status: :ok, location: @expansion }
      else
        format.html { render :edit }
        format.json { render json: @expansion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expansions/1
  # DELETE /expansions/1.json
  def destroy
    @expansion.destroy
    respond_to do |format|
      format.html { redirect_to expansions_url, notice: 'Expansion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expansion
      @expansion = Expansion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expansion_params
      params.require(:expansion).permit(:name, :code, :magic_rarities_codes, :release_date, :border, :type, :cards, :old_code, :gatherer_code, :block, :booster, :online_only)
    end
end
