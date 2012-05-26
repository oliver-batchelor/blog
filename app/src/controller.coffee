'use strict';


@Controller = (scope, location, routeParams) ->

  currentPage = -> location.url().split('/')[1];

  scope.normalizeDate = (dateTimeStr) -> new Date(dateTimeStr).toLocaleDateString();
  scope.isActive = (path) -> if currentPage() == path then "active" else "";

  scope.tags = ->
    containsPage = (article) ->_.any(article.pages, (page) -> page == currentPage())
    countWords = (counts, word) ->
      counts[word] = (counts[word] || 0) + 1
      return counts

    return _.chain(scope.articles).values()
      .filter(containsPage)
      .pluck("tags")
      .flatten()
      .reduce(countWords, {})
      .value();

  scope.articles =
    {
      0 : {
        id : 0,
        title: "Pictures of cats",
        date : "20:02:10 01/10/2012",
        tags : ["Pets", "Cats"],
        pages : ["home"]
      }, 1 : {
        title: "Dog designs",
        date : "5:02:10 05/05/2005",
        tags : ["Pets", "Dogs", "Sally"],
        pages : ["home"]
      }, 2 :  {
        title: "Sundials",
        date : "5:02:10 05/05/2005",
        tags : ["Lyttleton", "Sundials"],
        pages : ["design", "home"]
      }, 3 :  {
        title: "Water colors",
        date : "5:02:10 05/05/2005",
        tags : ["Painting", "Watercolor"],
        pages : ["home", "art"]
      },  4 :  {
        title: "Mums garden",
        date : "5:02:10 05/05/2005",
        tags : ["My House", "Sundials"],
        pages : ["design", "home"]
      }
    }



@Controller.$inject = ['$scope', '$location', '$routeParams'];

@HomeController =  (scope) ->
  scope.content =
    {
      0: "<h1> Here\'s a dgsd <h1> </h1></h1><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p>\n    ",
      1: "<h1> Here\'s a dgsd <h1> </h1></h1><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p>\n    ",
      2: "<h1> Here\'s a asdf <h1> </h1></h1><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p>\n    ",
      3: "<h1> Here\'s a ff <h1> </h1></h1><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p><p>Here\'s my article about cats isn\'t it wonderful Here\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderfulHere\'s my article about cats isn\'t it wonderful<p>\n    "
    }

@HomeController.$inject = ['$scope'];

###