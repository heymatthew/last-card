/* global $, d3 */
/* eslint-disable no-console */

$(document).ready(function() {
  var CARD_HEIGHT = 150;
  var CARD_WIDTH = 100;

  function keyedByCard(card) {
    return [card.rank, card.suit].join(',');
  }

  function inDeck(card) {
    return card.position == 'deck';
  }

  function randomColor() {
    return '#'+((1<<24)*Math.random()|0).toString(16);
  }

  function seedRandom(seed) { 
    return function myRandom() {
      var x = Math.sin(seed++) * 10000;
      return x - Math.floor(x);
    };
  }

  function tuneDelays(msDelay, itemsCount) {
    return function myDelay(d, i) {
      //return i / itemsCount * msDelay;
      return i / itemsCount * msDelay;
    };
  }

  function positionDeck(cardCount) {
    return function(c, i) {
      var offset = cardCount + i;
      var position = 'translate(50,50)';
      var stack = 'translate(' + offset + ',' + offset + ')';
      var rotate = 'skewX(-10) skewY(10)';
      return [position, stack, rotate].join(' ');
    };
  }

  function positionCardPile(c, i) {
    var rotation = seedRandom(i)() * 180;
    var position = 'translate(800,'+ (CARD_HEIGHT) +')';
    var rotate = 'rotate(' +
      rotation + ',' +
      (CARD_WIDTH/2+10).toString() + ',' +
      (CARD_HEIGHT/2+10).toString() +
    ')';
    return [position, rotate].join(' ');
  }

  function positionHand(middle, baseAngle) {
    return function fanOutCard(card, i) {
      var angle = (i - middle) * baseAngle;
      var position = 'translate(500,700)';
      var rotate = 'rotate(' + angle + ', ' + (CARD_WIDTH/2) + ', '+ -CARD_HEIGHT+')';
      return [position, rotate].join(' ');
    };
  }

  var svg = d3.select('#table')
    .append('svg')
    .attr('height', '100%')
    .attr('width', '100%')
  ;

  d3.json(document.location + '/rounds')
    .header('Content-Type', 'application/json')
    .get(function(error, roundData) {
      if(error) {
        return console.error(error);
      }

      var cards = svg.selectAll('.card').data(roundData, keyedByCard);

      // Render nerw cards with rectangles
      cards.enter()
        .append('g').classed('card', true)
        .append('rect')
          .attr('height', CARD_HEIGHT)
          .attr('width', CARD_WIDTH)
          .attr('fill', randomColor)
      ;

      // Render deck...
      renderDeck(cards);
      renderHand(cards);
      setTimeout( function() { renderPile(cards); }, 2000);
      setTimeout( function() { renderDeck(cards); }, 4000);
    })
  ;

  function renderDeck(cards) {
    var cardCount = cards[0].length;
    cards.transition()
      .delay(tuneDelays(1000, cardCount)) // stagger transitions over a second
      .duration(1000)                           // transition each card for 1/4 of a second
      .ease('exp-in-out')                       // as if the user flicked it into the table
      .attr('transform', positionDeck(cardCount))
    ;
  }

  function renderPile(cards) {
    cards.transition()
      .delay(tuneDelays(1000, cards[0].length)) // stagger transitions over a second
      .duration(1000)                           // transition each card for 1/4 of a second
      .ease('exp-in-out')                       // as if the user flicked it into the table
      .attr('transform', positionCardPile)      // to a position in the pile
    ;
  }

  function renderHand(cards) {
    var count = cards[0].length;
    var middle = parseFloat(count, 10) / 2;
    var baseAngle = 1/count * 45 - 90; // fan out in a V

    cards.transition()
      .delay(tuneDelays(1000, cards[0].length)) // stagger transitions over a second
      .duration(1000)                           // transition each card for 1/4 of a second
      .ease('exp-in-out')                       // as if the user flicked it into the table
      .attr('transform', positionHand(middle, baseAngle)) // to a position in the hand
    ;
  }

  //function renderHand(cards) {
  //  // Render pickups to hand
  //  handCards.enter()
  //    .append('g').classed('card', true)
  //    .append('rect')
  //    .attr('y', '-20%')
  //    .attr('fill', randomColor)
  //  ;

  //  // Setup card dimensions
  //  handCards.select('rect')
  //    .attr('height', '150')
  //    .attr('width', '100')
  //  ;

  //  handCards.transition()
  //    .attr('transform', rotateCardTransform(data.length))
  //      .delay(function(d, i) { return (data.length - i) / data.length * 100; })
  //      .duration(200)
  //      .ease('cubic')
  //  ;

  //  d3.transition(handCards).ease
  //  ;

  //  return handCards;
  //}
});
