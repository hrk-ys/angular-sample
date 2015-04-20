'use strict';
angular.module('angularSample')
.run(function($httpBackend){
    // No need to deal with tempaltes
    $httpBackend.expectPOST(/.*/);
});
