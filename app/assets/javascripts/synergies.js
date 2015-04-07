$(document).on('ready page:load', function(){
  if(!$('body.controller-decks.action-edit').length) { return }
  $('#connections-tab').on('click', function() {
    if(synergiesGraph.cy){ return }
    setTimeout( synergiesGraph.load, 500);
  });
  $( graphInterface.pileLinks ).on('click', graphInterface.pileClick );
  $( '#many-to-one-btn' ).on('click', graphInterface.manyToOne );
  $( '#many-to-many-btn' ).on('click', graphInterface.manyToMany );
  $( '#remove-btn' ).on('click', graphInterface.remove );
});

var synergiesGraph = {
  cy: false,
  containerSelector: '#cy',
  load: function() {
    $.getJSON( "synergies", function( data ) {
      synergiesGraph.nodes = data.nodes;
      synergiesGraph.edges = data.edges;
      synergiesGraph.init();
    });
  },
  init: function() {
    synergiesGraph.cy = cytoscape({
      container: $( synergiesGraph.containerSelector )[0],
      
      style: cytoscape.stylesheet()
        .selector('node')
          .css({
            'content': 'data(name)',
            'text-valign': 'center',
            'text-outline-width': 0,
            'font-family': 'Bree Serif',
            'color': '#333',
            'line-color': '#333',
            'background-color': '#EEE',
            'target-arrow-color': '#CCC',
            'source-arrow-color': '#CCC',
            'text-outline-color': '#CCC'
          }),
      
      elements: {
        nodes: synergiesGraph.nodes,
        edges: synergiesGraph.edges,
      },
      
      layout: {
        name: 'springy',
      
        animate: true, // whether to show the layout as it's running
        maxSimulationTime: 6000, // max length in ms to run the layout
        ungrabifyWhileSimulating: false, // so you can't drag nodes during layout
        fit: true, // whether to fit the viewport to the graph
        padding: 30, // padding on fit
        boundingBox: undefined, // constrain layout bounds; { x1, y1, x2, y2 } or { x1, y1, w, h }
        random: false, // whether to use random initial positions
        infinite: false, // overrides all other options for a forces-all-the-time mode
        ready: undefined, // callback on layoutready
        stop: undefined, // callback on layoutstop
      
        // springy forces
        stiffness: 300,
        repulsion: 400,
        damping: 0.5
      }
    });
  },
  
  edges: [],
  nodes: [],
  
  // cy.on('tap', 'node', ontTap)
  onTap: function() {
    this.data('propertyName');
  }
  
};

var graphInterface = {
  pileLinks: '.synergies-deck .card-list-item a',
  center: 'center-pile',
  selected: 'selected-pile',
  anyCenters: '.card-list-item .center-pile',
  pileClick: function() {
    var $link = $(this);
    if($link.hasClass( graphInterface.center )){ 
      // if the clicked link is a center
      // make it normal
      $link.removeClass( graphInterface.center ); 
    } else if ( $link.hasClass( graphInterface.selected ) ) { 
      // if it's selected,
      // make it center, and make all other centers, selected
      $link.removeClass( graphInterface.selected ); 
      $( graphInterface.anyCenters ).
        removeClass( graphInterface.center ).
        addClass( graphInterface.selected );
      $link.addClass( graphInterface.center );
    } else {
      // otherwise, make the link selected.
      $link.addClass( graphInterface.selected ); 
    }
  },
  selected_ids: function() {
    var ids = [];
    $('.' + graphInterface.selected).each(function(){
      ids.push($(this).parent().data('pile-id'));
    });
    return ids;
  },
  center_id: function() {
    return $('.' + graphInterface.center).
      parent().
      data('pile-id');
  },
  manyToMany: function() {
    graphInterface.query('many-to-many', 'POST');
  },
  manyToOne: function() {
    graphInterface.query('many-to-one', 'POST');
  },
  remove: function() {
    graphInterface.query('', 'DELETE');
  },
  clearHighlighting: function() {
    $(graphInterface.pileLinks).
      removeClass(graphInterface.center).
      removeClass(graphInterface.selected);
  },
  query: function(type, method) {
    $.ajax({
      method: method,
      url: "/synergies",
      dataType: "json",
      data: {type: type, pile_ids: graphInterface.selected_ids(), center_pile: graphInterface.center_id() },
      complete: function(data) {
        synergiesGraph.load();
      }
    });
    graphInterface.clearHighlighting();
  }
  
};