$(document).on('ready page:load', function(){
  $(document).off('previewReloaded deckListReloaded');
  if($('body.controller-decks.action-edit').length) { //if we're editing.
  
    $('#tabs').tab();
    
    $('#connections-tab').on('click', function() {
      if(!SynergiesGraph.cy){ setTimeout( SynergiesGraph.load, 500); }
    });
    
    $( '#create-links-btn' ).on('click', GraphInterface.create );
    $( '#remove-links-btn' ).on('click', GraphInterface.remove );
    
    $('#autocomplete-cards').on("keypress", Autocomplete.onEnter);
    $('.add-remove-button').on('ajax:complete', Decklist.adjustComplete ); 
    
    $( GraphInterface.pileLinks ).on('click', GraphInterface.pileClick );
    $(document).on('deckListReloaded', function() {
      $('.card-list-item a').hoverIntent( Preview.cardMouseover );
      $( GraphInterface.pileLinks ).on('click', GraphInterface.pileClick );
    });
  
    $(document).on('previewReloaded deckListReloaded', function() {
      $('.add-remove-button').off('ajax:complete').on('ajax:complete', Decklist.adjustComplete ); 
    });
  
  } else { 
    if($('body.controller-decks.action-show').length) { 
      SynergiesGraph.load(); 
    }
 
    $('.card-list-item a').hoverIntent( Preview.cardMouseover );
    
    $('.add-remove-button').off('ajax:complete').on('ajax:complete', NotifyBar.adjustComplete );
    $(document).on('previewReloaded', function() {
      $('.add-remove-button').off('ajax:complete').on('ajax:complete', NotifyBar.adjustComplete );
    });
  }
  $('.card-list-item a').hoverIntent( Preview.cardMouseover );
  $('#autocomplete-cards').bind('railsAutocomplete.select', Preview.autocompleteSelect );
  
});