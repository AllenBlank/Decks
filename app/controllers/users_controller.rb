class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    @decks = @user.decks.order(updated_at: :desc).limit(10)
    @searches = @user.searches.order(updated_at: :desc).limit(10)
  end
end
