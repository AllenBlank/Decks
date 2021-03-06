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
    var deckURL = Decklist.deckURL();
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
    $(Decklist.selector).html(html).fadeTo(500, 0.2, function(){
      $(this).fadeTo(500, 1);
    });
    $(document).trigger('deckListReloaded');
    
    if( Decklist.triedRecently ){
      Decklist.triedRecently = false;
      Decklist.fetch();
    }
  },
  adjustComplete: function(e, data, status, xhr) {
    Decklist.refresh();
  },
  deckURL: function() {
    return '/decks/' + $(Decklist.selector).data('id');
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


