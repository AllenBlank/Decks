require 'test_helper'

class DecksControllerTest < ActionController::TestCase
  setup do
    @deck = decks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:decks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deck" do
    assert_difference('Deck.count') do
      post :create, deck: { commander_id: @deck.commander_id, description: @deck.description, format: @deck.format, name: @deck.name, user_id: @deck.user_id }
    end

    assert_redirected_to deck_path(assigns(:deck))
  end

  test "should show deck" do
    get :show, id: @deck
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deck
    assert_response :success
  end

  test "should update deck" do
    patch :update, id: @deck, deck: { commander_id: @deck.commander_id, description: @deck.description, format: @deck.format, name: @deck.name, user_id: @deck.user_id }
    assert_redirected_to deck_path(assigns(:deck))
  end

  test "should destroy deck" do
    assert_difference('Deck.count', -1) do
      delete :destroy, id: @deck
    end

    assert_redirected_to decks_path
  end
end
