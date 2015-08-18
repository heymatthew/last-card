/* global $, d3 */
/* eslint-disable no-console */

$(document).ready(function() {
  var CARD_HEIGHT = 150;
  var CARD_WIDTH = 100;
  var SEED = new Date().getTime() * Math.random();

  function keyedByCard(card) {
    return [card.rank, card.suit].join(',');
  }

  function filterInDeck(card) {
    return card.position === 'deck';
  }

  function filterInPile(card) {
    return card.position === 'pile';
  }

  function filterPlayer(nickname) {
    return function(card) {
      return card.position === nickname;
    };
  }

  function rotateTransformCard(rotation) {
    return 'rotate(' +
      rotation + ',' +
      (CARD_WIDTH/2+10).toString() + ',' +
      (CARD_HEIGHT/2+10).toString() +
    ')';
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

  function staggeredDelay(msDelay, itemsCount) {
    return function myDelay(d, i) {
      return i / itemsCount * msDelay;
    };
  }

  function positionDeck(cards) {
    var cardCount = cards[0].length;
    var random = seedRandom(SEED);

    return function(c, i) {
      var offset = cardCount + i;
      var angle = random() * 4 - 2;
      var position = 'translate(50,50)';
      var stack = 'translate(' + offset + ',' + offset + ')';
      var slightRotation = rotateTransformCard(angle)
      var perspective = 'skewX(-10) skewY(10)';
      return [position, stack, slightRotation, perspective].join(' ');
    };
  }

  function positionPile() {
    var random = seedRandom(SEED);

    return function(c, i) {
      var rotation = random() * 180;
      var position = 'translate(800,'+ (CARD_HEIGHT) +')';
      var rotate = rotateTransformCard(rotation);
      return [position, rotate].join(' ');
    };
  }

  function positionHand(cards) {
    var count = cards[0].length;
    var middle = parseFloat(count, 10) / 2;
    var baseAngle = 1/count * 45 - 90; // fan out in a V

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

      cards.attr('transform', positionDeck(cards));

      //everythingFlysAround(cards);
    })
  ;

  function everythingFlysAround(cards) {
    function render() {
      transitionFlickOut(cards)
        .attr('transform', positionHand(cards));

      setTimeout(function() {
        transitionFlickOut(cards)
          .attr('transform', positionPile(cards));
      },2000);

      setTimeout(function() {
        transitionFlickOut(cards)
          .attr('transform', positionDeck(cards));
      },4000);
    }

    render();
    setInterval(render, 6000);
  }

  function transitionFlickOut(cards) {
    var animationTime = 750; // ms
    var cardCount = cards[0].length;

    return cards.transition()
      .delay(staggeredDelay(animationTime, cardCount)) // stagger transitions over a second
      .duration(animationTime)                         // transition over 1/2 a second
      .ease('exp-in-out')                              // as if the user flicked it into the table
    ;
  }
});
