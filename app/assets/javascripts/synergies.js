var synergiesGraph = {
  cy: false,
  containerSelector: '#cy',
  init: function() {
    synergiesGraph.cy = cytoscape({
      container: $( synergiesGraph.containerSelector )[0],
      
      style: cytoscape.stylesheet()
        .selector('node')
          .css({
            'content': 'data(name)',
            'text-valign': 'center',
            'text-outline-width': 2,
            'color': '#EEE',
            'line-color': '#333',
            'background-color': '#333',
            'target-arrow-color': '#333',
            'source-arrow-color': '#333',
            'text-outline-color': '#333'
          }),
      
      elements: {
        nodes: synergiesGraph.nodes,
        edges: synergiesGraph.edges,
      },
      
      layout: {
        name: 'springy',
      
        animate: true, // whether to show the layout as it's running
        maxSimulationTime: 4000, // max length in ms to run the layout
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
  
  edges: [
    { data: { source: '1',  target: '2' } },
    { data: { source: '2',  target: '1' } },
  ],
  nodes: [
    { data: { id: '1',  name: 'One' } },
    { data: { id: '2',  name: 'Two' } },
  ],
  
  // cy.on('tap', 'node', ontTap)
  onTap: function() {
    this.data('propertyName');
  }
  
};

$(document).on('ready page:load', function(){
  if(!$('body.controller-decks.action-edit').length) { return }
  $('#connections-tab').on('click', function() {
    if(synergiesGraph.cy){ return }
    setTimeout( synergiesGraph.init, 500);
  });
});