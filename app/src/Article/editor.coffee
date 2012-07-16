

Editor = angular.module 'Editor', ['Article']


Editor.directive 'bindHtml', () -> {

  restrict: 'A',
  require: 'ngModel',

  link: (scope, element, attrs, ngModel) ->

    lastHtml = ngModel.$viewValue

    ngModel.$render = () ->
      if lastHtml != ngModel.$viewValue
        element.html ngModel.$viewValue


    element.bind 'blur keyup paste', () ->

      scope.$apply () ->
        lastHtml = element.html()
        ngModel.$setViewValue(element.html())
  }




Editor.directive 'uiFocus', () -> {

  restrict: 'A',

  link: (scope, element, attrs, ngModel) ->
    value = attrs['hasFocus']

    element.bind 'focus', () ->
      scope.$apply () -> scope[value] = true

    element.bind 'focusout', () ->
      scope.$apply () -> scope[value] = false
}



paragraphHtml =
    "<p style='border: 1px red solid'>" +
      "<span ng-repeat='object in content.children' class='inline-object'>" +
        "<ng-switch on='object.type'>" +
          "<edit-span content='object' path='path + \".\" + $index' ng-switch-when='span' edit-state='editState'></edit-span>" +
          "<figure-embed content='object' ng-switch-when='figure'></figure-embed>" +
          "<br ng-switch-when='break'>"  +
        "</ng-switch>" +
      "</span>" +
    "</p>"


Editor.directive 'editParagraph', () -> {

  template: paragraphHtml,
  restrict: 'E',

  scope: {
    content : '=',
    path    : '=',
    editState : '='
  },

  link: (scope, element) ->

    element.bind 'drop', (event) ->
      console.log 'drop', event
      event.preventDefault()

}



whenString = (cond, value) -> if cond then value else ""


Editor.directive 'editSpan', () -> {
  restrict: 'E',

  scope: {
    content : '=',
    path    : '=',
    editState : '='
  },


  link: (scope, element, attribs) ->

    escape = (text) -> text.replace(/\s/g, '&nbsp')
    makeSpans = (text, cursor) ->
      chars = text.split('')
      chars.push '' # For cursor which is off the end

      n = 0
      wrap = (text) ->

        cursorElem = "<span id='cursor'></span>"
        "#{whenString n == cursor, cursorElem}<c i='#{n++}'>#{escape text}</c>"

      (chars.map wrap).join('')

    obsCursor = (cursor) ->
      if scope.path == cursor.path
        pos = cursor.char

      if(scope.cursor != undefined || pos != undefined)

        element.html (makeSpans scope.content.text, pos)

      scope.cursor = pos

    scope.$watch 'editState.cursor', obsCursor, true

    scope.$watch 'content.text', (text) ->
      element.html (makeSpans text, scope.cursor)

    scope.$watch 'content.format', (format) ->

      element.css {
        fontWeight: if format.bold then 'bold'
        fontStyle: if format.italic then 'italic'
        color : format.color
      }
}

figureHtml = """
  <div ng-class="['figure', content.alignment]"  unique-id draggable="true">
     <img draggable="false"></img>
    <div class="caption-right">{{content.caption}}</div>
  </div>
"""


Editor.directive 'figureEmbed', () -> {
  restrict: 'E',

  scope: { content : '=' },
  template: figureHtml,

  link: (scope, element, attribs) ->
    scope.$watch 'content.source', (value) ->
      (scope.$query 'img').attr 'src', value


    element.bind 'dragstart', (event) ->

      console.log 'drag'
      event.dataTransfer.setData("text", scope.content);
      event.dataTransfer.effectAllowed = "all";
      #event.preventDefault()

}


articleHtml =
  """
    <div class="content" unique-id>
        <div ng-repeat="block in content.children">

            <ng-switch on="block.type">

           <h1 ng-switch-when="heading">
              {{block.title}}
           </h1>

           <edit-paragraph content="block" path="$index" ng-switch-when="para" edit-state="editState"></edit-paragraph>

        </ng-switch>
      </div>
    </div>
  """


Editor.factory '$uniqueId', () ->
  id = { count: 0 }

  id.newId = () ->
    id.count++
    return "u#{id.count}"

  return id


Editor.directive 'uniqueId', ($uniqueId) -> {
  restrict: 'A',

  link: (scope, element, attrs) ->

    scope.$id = $uniqueId.newId()
    element.attr("id", scope.$id)

    #JQuery on the Id
    scope.$query = (selector) -> $("##{scope.$id} #{selector}")
}



Editor.directive 'editor', ($window, $document) -> {
  template: articleHtml,
  restrict: 'E',

  scope: { content : '=' },
  controller: 'ArticleCtrl',

  link: (scope, element, attrs) ->

#    angular.element(element).bind "keypress", (event) ->
#      event.preventDefault()

    # Detect when parts of the article are selected

    article = element[0]
    element.bind 'dragover', (event) ->
      chars = []

      (scope.$query 'c').each (index, charNode) ->

        charElem = angular.element(charNode)
        charElem.css('border', index)

        chars.push charNode.textContent
        chars.push (JSON.stringify  (DomTools.offsetTo article, charNode))
        chars.push (charElem.scope().path)
        chars.push(charElem.attr('i'))

      console.log chars

        #$(elem1).offset({ relativeTo : element })
#      selection = window.getSelection()
#      range = selection.getRangeAt 0
#
#      console.log range

    n = 0
    element.attr 'tabindex', '0'

    element.bind "focus", (event) ->
      $('body').addClass "noselect"
      element.addClass "selectall"

    element.bind "focusout", (event) ->
      $('body').removeClass "noselect"
      element.removeClass "selectall"

    element.bind "keydown", (event) -> scope.$apply () ->

      switch(event.keyCode)
        when KeyCodes.DOM_VK_LEFT then scope.moveLeft()
        when KeyCodes.DOM_VK_RIGHT then scope.moveRight()
        when KeyCodes.DOM_VK_UP then console.log "up"
        when KeyCodes.DOM_VK_DOWN then console.log "down"

      event.preventDefault()

    docElem = angular.element(document)
    docElem.bind "mouseup paste", (event) ->


      selection = window.getSelection()
      range = selection.getRangeAt 0


      if DomTools.isDescendant article, range.commonAncestorContainer
        console.log range


#        position = 0;
#        start = false;
#
#        DomTools.traverse article, (node) ->
#            inner = angular.element(node)
#
#            if inner.hasClass "inline-object"
#              object = inner.scope().object
#              console.log node, object, (DomTools.isDescendant node, range.startContainer), (DomTools.isDescendant node, range.endContainer)




}


