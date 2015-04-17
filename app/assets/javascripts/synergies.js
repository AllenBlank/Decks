$(document).on('ready page:load', function(){
  if($('body.controller-decks.action-show').length) { SynergiesGraph.load(); }
  if(!$('body.controller-decks.action-edit').length) { return }
  $('#connections-tab').on('click', function() {
    if(SynergiesGraph.cy){ return }
    setTimeout( SynergiesGraph.load, 500);
  });
  $( GraphInterface.pileLinks ).on('click', GraphInterface.pileClick );
  $( '#many-to-one-btn' ).on('click', GraphInterface.manyToOne );
  $( '#many-to-many-btn' ).on('click', GraphInterface.manyToMany );
  $( '#remove-btn' ).on('click', GraphInterface.remove );
});

var SynergiesGraph = {
  cy: false,
  containerSelector: '#cy',
  load: function() {
    var synergiesURL =  Decklist.deckURL() + '/synergies';
    $.getJSON( synergiesURL, function( data ) {
      SynergiesGraph.nodes = data.nodes;
      SynergiesGraph.edges = data.edges;
      SynergiesGraph.init();
    });
  },
  init: function() {
    SynergiesGraph.cy = cytoscape({
      container: $( SynergiesGraph.containerSelector )[0],
      
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
        nodes: SynergiesGraph.nodes,
        edges: SynergiesGraph.edges,
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

var GraphInterface = {
  pileLinks: '.synergies-deck .card-list-item a',
  center: 'center-pile',
  selected: 'selected-pile',
  anyCenters: '.card-list-item .center-pile',
  pileClick: function() {
    var $link = $(this);
    if($link.hasClass( GraphInterface.center )){ 
      // if the clicked link is a center
      // make it normal
      $link.removeClass( GraphInterface.center ); 
    } else if ( $link.hasClass( GraphInterface.selected ) ) { 
      // if it's selected,
      // make it center, and make all other centers, selected
      $link.removeClass( GraphInterface.selected ); 
      $( GraphInterface.anyCenters ).
        removeClass( GraphInterface.center ).
        addClass( GraphInterface.selected );
      $link.addClass( GraphInterface.center );
    } else {
      // otherwise, make the link selected.
      $link.addClass( GraphInterface.selected ); 
    }
  },
  selected_ids: function() {
    var ids = [];
    $('.' + GraphInterface.selected).each(function(){
      ids.push($(this).parent().data('pile-id'));
    });
    return ids;
  },
  center_id: function() {
    return $('.' + GraphInterface.center).
      parent().
      data('pile-id');
  },
  manyToMany: function() {
    GraphInterface.query('many-to-many', 'POST');
  },
  manyToOne: function() {
    GraphInterface.query('many-to-one', 'POST');
  },
  remove: function() {
    GraphInterface.query('', 'DELETE');
  },
  clearHighlighting: function() {
    $(GraphInterface.pileLinks).
      removeClass(GraphInterface.center).
      removeClass(GraphInterface.selected);
  },
  query: function(type, method) {
    $.ajax({
      method: method,
      url: "/synergies",
      dataType: "json",
      data: {type: type, pile_ids: GraphInterface.selected_ids(), center_pile: GraphInterface.center_id() },
      complete: function(data) {
        SynergiesGraph.load();
      }
    });
    GraphInterface.clearHighlighting();
  }
  
};