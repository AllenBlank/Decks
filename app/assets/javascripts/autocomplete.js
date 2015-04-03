$(document).on('ready page:load', function() {
  $('#autocomplete-cards').bind('railsAutocomplete.select', function(event, data){
    var id = data.item.id;
    previewByID(id);
  });
  
  $('.card-list-item a').on('mouseover', function() {
    var id = $(this).parent().data("id");
    previewByID(id);
  });
  
});

var alreadyFetched = {};
var recentHTML = "";

function previewByID(id) {
  if ( alreadyFetched[id] ) {
    if ( alreadyFetched[id] != "" ) {
      var html = alreadyFetched[id].responseJSON.partialHTML;
      setPreview(html);
    }
  } else {

    alreadyFetched[id] = "";
    var cardURL = '/cards/' + id;
    $.ajax({
      method: "GET",
      url: cardURL,
      dataType: "json",
      complete: function(data) {
        alreadyFetched[id] = data;
        var html = data.responseJSON.partialHTML;
        setPreview(html);
      }
    });
  }
}

function setPreview(html) {
  if (recentHTML == html) return;
  
  recentHTML = html;
  $('#card-preview').fadeOut(300, function(){
    $('#card-preview').html( html );
    $('#card-preview img').load(function(){
      $('#card-preview').fadeIn(300,function(){});
    });
  });
  
}