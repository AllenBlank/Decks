class StaticPagesController < ApplicationController
  autocomplete :card, :name, limit: 10
   
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items.where(newest: true)
  end
  
  def home
  end

  def about
  end
end
