$(document).on('ready page:load', function() {
  $('#autocomplete-cards').bind('railsAutocomplete.select', function(event, data){
    var id = data.item.id;
    var cardURL = 'cards/' + id;
    $.ajax({
      method: "GET",
      url: cardURL,
      dataType: "json",
      complete: function(data) {
        var html = data.responseJSON.partialHTML;
        $('#card-preview').html( html );
      }
    });
  });
});
