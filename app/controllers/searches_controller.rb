class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :update, :destroy]
  before_action :check_correct_user, only: [:update, :destroy]
  
  autocomplete :card, :name, limit: 10
  def get_autocomplete_items(parameters)
    super(parameters).where(newest: true)
  end
  
  def index
    @user = User.find( params[:user_id] )
    @searches = @user.searches.
                       order(updated_at: :desc).
                       paginate(page: params[:page], per_page: 10)
  end
  
  def new
    @search ||= Search.new
  end
  
  def update
    @search.update search_params
    redirect_to @search
  end
  
  def create
    @search = Search.create search_params
    current_user.searches << @search if logged_in?

    msg = "Found #{ ActionController::Base.helpers.pluralize(@search.cards.count, 'card') }."
    (@search.cards.count > 0) ? flash[:success] = msg : flash[:danger] = msg
    
    redirect_to @search
  end
  
  def show
    @cards = @search.cards.paginate(page: params[:page], per_page: 10)
    
    redirect_to @cards.first if @cards.count == 1
  end
  
  def destroy
    @search.destroy
    redirect_to root_path
  end
  
  private
  
    def set_search
      @search = Search.find(params[:id])
    end
    
    def most_recent_search
      current_user.searches.last unless logged_in? && current_user.searches.empty?
    end
    
    def search_params
      params.require(:search).permit( :name_field, 
                                      :text_field, 
                                      :type_field, 
                                      :format_field, 
                                      :advanced_field, 
                                      :exact_field, 
                                      :sort_by_field,
                                      :sort_direction_field,
                                      colors: [] )
    end
  
    def check_logged_in
      bounce_chumps "You need to be logged in." unless logged_in?
    end
    
    def check_correct_user
      bounce_chumps "You're the wrong user." unless @search.user == current_user
    end
    
end
