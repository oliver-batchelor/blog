'use strict';


## Declare app level module which depends on filters, and services
angular.module('App', ['Blog', 'Editor']).

config ['$routeProvider',(routeProvider) ->
  routeProvider.when '/about', {templateUrl: 'partials/about.html'}
  routeProvider.when '/:page',  {templateUrl: 'partials/page.html'}
  routeProvider.otherwise {redirectTo: '/home'}
]


