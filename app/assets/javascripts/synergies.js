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
    SynergiesGraph.cy.boxSelectionEnabled( true ); // fix scrolling problems.
    SynergiesGraph.cy.zoomingEnabled( false );
    SynergiesGraph.cy.on('tap', 'node', GraphInterface.onNodeTap);
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
  selected: 'selected-pile',
  pileClick: function() {
    var $link = $(this);
    if($link.hasClass( GraphInterface.selected )){ 
      // if the clicked link is selected
      // make it normal
      $link.removeClass( GraphInterface.selected ); 
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
  create: function() {
    GraphInterface.query('POST');
  },
  remove: function() {
    GraphInterface.query('DELETE');
  },
  clearHighlighting: function() {
    $(GraphInterface.pileLinks).removeClass(GraphInterface.selected);
  },
  query: function(method) {
    $.ajax({
      method: method,
      url: "/synergies",
      dataType: "json",
      data: {pile_ids: GraphInterface.selected_ids() },
      complete: function(data) {
        SynergiesGraph.load();
      }
    });
    GraphInterface.clearHighlighting();
  },
  onNodeTap: function() {
    var name = this.data('name');
    $(GraphInterface.pileLinks + ":contains('" + name + "')").click();
  }
};