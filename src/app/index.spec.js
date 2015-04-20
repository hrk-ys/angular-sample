'use strict';

describe('timeago filter', function($filter) {

  beforeEach(module('angularSample'));

  var now = parseInt((new Date)/1000);
  var inputs  = [now,     now-60,  now-3600,  now-86400];
  var expects = ['0秒前', '1分前', '1時間前', '1日前'];
  it('returns 0sec when given now', inject(function(timeagoFilter) {
    for (var i=0; i<inputs.length; i++) {
        expect(timeagoFilter(inputs[i])).toEqual(expects[i]);
    }
  }));

});

