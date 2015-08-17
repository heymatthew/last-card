/* global $, d3 */
/* eslint-disable no-console */

$(document).ready(function() {
  function cardKey(card) {
    return [card.rank, card.suit].join(',');
  }

  function randomColor() {
    return '#'+((1<<24)*Math.random()|0).toString(16);
  }

  function rotateCardTransform(count) {
    var middle = parseFloat(count, 10) / 2;
    console.log(parseFloat(count));
    var baseRotation = 20.0; // degrees
    return function rotateCard(card, i) {
      var angle = (middle - i) * baseRotation;
      console.log(middle, i, middle - i, baseRotation, angle);
      return 'rotate(' + angle + ',50,100)';
    };
  }

  var svg = d3.select('#table')
    .append('svg')
    .attr('height', '100%')
    .attr('width', '100%')
  ;

  var hand =
    svg.append('g')
      .attr('transform', 'translate(200,500)')
      .classed('hand', true)
  ;

  d3.json(document.location + '/rounds')
    .header('Content-Type', 'application/json')
    .get(function(error, roundData) {
      if(error) {
        return console.error(error);
      }

      var cards = renderHand(roundData.hands['megatron']); // FIXME placeholder
      console.log(cards);
    })
  ;

  function renderHand(data) {
    var handCards = hand.selectAll('.card').data(data, cardKey);

    // Render pickups to hand
    handCards.enter()
      .append('rect')
      .attr('y', '-20%')
      .attr('fill', randomColor)
      .transition()
        .attr('transform', rotateCardTransform(data.length))
          .delay(function(d, i) { return (data.length - i) / data.length * 200; })
          .duration(100)
          .ease('quad')
    ;

    // Setup
    handCards
      .attr('y', '-20%')
      .attr('height', '150')
      .attr('width', '100')
    ;

    d3.transition(handCards).ease
    ;

    return handCards;
  }
});
