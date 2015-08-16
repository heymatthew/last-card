$(document).ready(function() {
  var url = $('#table').data('deck')

  var lookup = {
    'ace of clubs': {
      'identifier': '#g196926',
      'correction': 'translate(600,-110)'
    },
    'eight of clubs': {
      'identifier': '#g196820',
      'correction': 'translate(600,-110)'
    },
  };

  $.get( url ).then( function(deck) {
    var $deck = $(deck);

    function definitions() {
      return $deck.find('defs')[0];
    }

    function card(name) {
      var details = lookup[name];
      var $card = $deck.find(details.identifier);
      $card.attr('transform', details.correction);

      return function() { return $card[0]; }
    }

    var svg = d3.select("#table").append("svg")
      .attr("width", "100%")
      .attr("height", "100%")
    ;

    svg.append( card('eight of clubs') )
    svg.append( definitions )
  });
});
