'use strict';


## Declare app level module which depends on filters, and services
angular.module('blog', []).

config ['$routeProvider',(routeProvider) ->
  routeProvider.when '/home',  {template: 'partials/home.html', controller: HomeController}
  routeProvider.when '/about', {template: 'partials/about.html'}
  routeProvider.otherwise {redirectTo: '/home'}
]


