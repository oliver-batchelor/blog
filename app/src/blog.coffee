'use strict';

Blog = angular.module 'Blog', []


para = (content) -> { type: 'para', children: content }
span = (text, format) -> { type:'span', text: text, format: if format then format else {} }
br = { type: 'break' }

figure = (source, align, caption) -> { type: 'figure', source: source, alignment: align, caption: caption}



BlogCtrl = Blog.controller 'BlogCtrl', ['$scope', '$location', '$routeParams', (scope, location, routeParams) ->

  currentPage = -> location.url().split('/')[1];

  scope.normalizeDate = (dateTimeStr) -> new Date(dateTimeStr).toLocaleDateString();
  scope.isActive = (path) -> if currentPage() == path then "active" else "";

  scope.articles =
  {
    0 : {
      id : 0,
      title: "true",
      date : "20:02:10 01/10/2012",

      type: 'article',
      children: [
          (para [
            (span "123", {bold:true}),
            (span "1      asdf   1 >", {bold:false}),
            (figure "/img/loading-icon.gif", "inline", "Hello world"),
            (span "<  2  |"), br,
            (span "<  2  |"),
          ]),

          (para [
            (span "1      asdf   1", {bold:true}),
            (span "1      asdf   1 >", {bold:false}),
            (figure "/img/loading-icon.gif", "inline", "Hello world"),
            (span "<  2  "),
          ])

#          (para [
#            (span "Laura likes to ride on horses and often pretends to act like a horse.
#                   Her father eats like a horse and her mother likes horses too,")
#
#            (figure "/img/laura.jpg", "left", "Source: - I stole this from facebook.com")
#            (span "but probably not so much. Probably this should not be all about horses,
#                   her face is on a diagonal, which leads to a sore neck. Like a horse would have."),
#            (span "This is some kind"),
#            (span "of text whch is bold", {bold: true}),
#            (span "and that which is not", {color:'red'}),
#            (span "and that which is not", {color:'red', bold:true}),
#          ])

        ]

      pages : ["home", "inspiration"]
    }
  }
]
