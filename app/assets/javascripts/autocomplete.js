$(document).on('ready page:load', function() {
  $('#autocomplete-cards').bind('railsAutocomplete.select', Preview.autocompleteSelect );
  
  if(!$('body.controller-decks.action-edit').length) { return }
  $('#tabs').tab();
  
  $('#autocomplete-cards').on("keypress", Autocomplete.onEnter);
  $('.card-list-item a').hoverIntent( Preview.cardMouseover );
  $('.add-remove-button').on('ajax:complete', Decklist.adjustComplete ); 
  
  $(document).on('deckListReloaded', function() {
    $('.card-list-item a').hoverIntent( Preview.cardMouseover );
  });

  $(document).on('previewReloaded deckListReloaded', function() {
    $('.add-remove-button').off('ajax:complete').on('ajax:complete', Decklist.adjustComplete ); 
  });
});

var Decklist = {
  selector: '.full-deck',
  currentlyFetching: false,
  triedRecently: false,
  refresh: function() {
    if( Decklist.currentlyFetching ) {
      Decklist.triedRecently = true;
    } else {
      Decklist.fetch();
    }
  },
  fetch: function() {
    var deckURL = '/decks/' + $(Decklist.selector).data('id');
    $.ajax({
      method: "GET",
      url: deckURL,
      dataType: "json",
      beforeSend: function() {Decklist.currentlyFetching = true;},
      complete: Decklist.fetchCompleted
    });
  },
  fetchCompleted: function(data) {
    Decklist.currentlyFetching = false;
    
    var html = data.responseJSON.partialHTML;
    $(Decklist.selector).html(html);
    $(document).trigger('deckListReloaded');
    console.log('Decklist fetched!');
    
    if( Decklist.triedRecently ){
      Decklist.triedRecently = false;
      Decklist.fetch();
    }
  },
  adjustComplete: function(e, data, status, xhr) {
    Decklist.refresh();
  }
};

var Preview = {
  alreadyFetched: {},
  recentHTML: "",
  selector: '#card-preview',
  
  previewByID: function(id) {
    if ( Preview.alreadyFetched[id] ) {
      if ( Preview.alreadyFetched[id] != "" ) {
        var html = Preview.alreadyFetched[id].responseJSON.partialHTML;
        Preview.setPreview(html);
      }
    } else {
  
      Preview.alreadyFetched[id] = "";
      var cardURL = '/cards/' + id;
      $.ajax({
        method: "GET",
        url: cardURL,
        dataType: "json",
        complete: function(data) {
          Preview.alreadyFetched[id] = data;
          var html = data.responseJSON.partialHTML;
          Preview.setPreview(html);
        }
      });
    }
  },
  setPreview: function(html) {
    if (Preview.recentHTML == html) return;
  
    Preview.recentHTML = html;
    $(Preview.selector).fadeTo(300, 0, function(){
      $(Preview.selector).html( html );
      //$(Preview.selector + ' img').load(function(){
        $(Preview.selector).fadeTo(300, 1);
        $(document).trigger('previewReloaded');
      //});
    });
  },
  cardMouseover: function() {
    var id = $(this).parent().data("id");
    Preview.previewByID(id);
  },
  autocompleteSelect: function(event, data) {
    var id = data.item.id;
    Preview.previewByID(id);
  }
};

var Autocomplete = {
  selectedID: '',
  onSelect: function(event, data) {
    Autocomplete.selectedID = data.item.id;
  },
  addCard: function(cardID) {
    var deckURL = '/decks/' + $('.full-deck').data('id');
    $.ajax({
      method: "PATCH",
      url: deckURL,
      dataType: "javascript",
      data: {add_card: cardID},
      complete: function(data){ console.log('Card add complete!');}
    });
  },
  onEnter: function(e) {
    var code = e.keyCode || e.which; 
    if (code  == 13) {               
      e.preventDefault();
      Autocomplete.triggerSubmit();
      return false;
    }
  },
  triggerSubmit: function(){
    if($('.ui-menu-item').filter(':visible').length > 0 ) { return; }
    $('#card-preview .add-remove-button').first().submit();
  }
};


