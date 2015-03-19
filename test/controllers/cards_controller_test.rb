require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  setup do
    @card = cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create card" do
    assert_difference('Card.count') do
      post :create, card: { artist: @card.artist, border: @card.border, cmc: @card.cmc, colors: @card.colors, flavor: @card.flavor, foreign_names: @card.foreign_names, hand: @card.hand, image_name: @card.image_name, layout: @card.layout, legalities: @card.legalities, life: @card.life, loyalty: @card.loyalty, mana_cost: @card.mana_cost, multiverseid: @card.multiverseid, name: @card.name, names: @card.names, number: @card.number, original_text: @card.original_text, original_type: @card.original_type, power: @card.power, printings: @card.printings, rarity: @card.rarity, release_date: @card.release_date, reserved: @card.reserved, rulings: @card.rulings, source: @card.source, starter: @card.starter, subtypes: @card.subtypes, supertypes: @card.supertypes, text: @card.text, timeshifted: @card.timeshifted, toughness: @card.toughness, type: @card.type, types: @card.types, variations: @card.variations, watermark: @card.watermark }
    end

    assert_redirected_to card_path(assigns(:card))
  end

  test "should show card" do
    get :show, id: @card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @card
    assert_response :success
  end

  test "should update card" do
    patch :update, id: @card, card: { artist: @card.artist, border: @card.border, cmc: @card.cmc, colors: @card.colors, flavor: @card.flavor, foreign_names: @card.foreign_names, hand: @card.hand, image_name: @card.image_name, layout: @card.layout, legalities: @card.legalities, life: @card.life, loyalty: @card.loyalty, mana_cost: @card.mana_cost, multiverseid: @card.multiverseid, name: @card.name, names: @card.names, number: @card.number, original_text: @card.original_text, original_type: @card.original_type, power: @card.power, printings: @card.printings, rarity: @card.rarity, release_date: @card.release_date, reserved: @card.reserved, rulings: @card.rulings, source: @card.source, starter: @card.starter, subtypes: @card.subtypes, supertypes: @card.supertypes, text: @card.text, timeshifted: @card.timeshifted, toughness: @card.toughness, type: @card.type, types: @card.types, variations: @card.variations, watermark: @card.watermark }
    assert_redirected_to card_path(assigns(:card))
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete :destroy, id: @card
    end

    assert_redirected_to cards_path
  end
end
