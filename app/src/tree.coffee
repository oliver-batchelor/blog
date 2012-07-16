
treeHtml =
  """
   <div style="padding-left:10px;" drag="node">

        <div>{{node.name}}

      <button ng-click="add(node)">+</button>
      <button ng-hide="parent == undefined" ng-click="delete(parent, node)">x</button>

    </div>

      <div ng-repeat="child in node.children">
        <tree node="child" parent="node"></tree>
       </div>
   </div>

    """


@Presentation.directive 'tree', ($compile) -> {

restrict: 'E',
scope: {
node: "="
parent: "="
}

link : (scope, elem, attrs) ->
  scope.n = 0

  scope.add = (node) ->
    newNode = { name: "New child " + scope.n++, children : [] }
    node.children.push(newNode)

  scope.delete = (parent, node) ->
    i = parent.children.indexOf node
    parent.children.splice(i, 1)


  elem.append ($compile treeHtml) scope
}

@Presentation.directive 'drag', ($document, $rootScope) -> {


link : (scope, element, attr) ->
  startX = 0; startY = 0;

  element.addClass 'dragable'

  element.bind 'mousedown', (event) ->
    startX = event.screenX
    startY = event.screenY

    $document.bind 'mousemove', mousemove
    $document.bind 'mouseup',  mouseup

    angular.element(document.body).addClass("noselect");

    $rootScope.$broadcast 'drag', scope.$eval(attr.drag)
    event.stopPropagation()

  mousemove = (event) ->
    y = event.screenY - startY
    x = event.screenX - startX

    element.css {
    top: y + 'px',
    left:  x + 'px'
    }

  mouseup = () ->
    $document.unbind 'mousemove', mousemove
    $document.unbind 'mouseup', mouseup

    angular.element(document.body).removeClass("noselect");

    element.css {
    top: 0 + 'px',
    left:  0 + 'px'
    }
}

#@Presentation.directive 'target', ($document) -> {
#
#  restrict: 'A',
#
#
#  link: (scope, element, attr) ->
#
#    scope.$on 'drag', (event, drag) ->
#
#
#      mousemove = (event) ->
#        if drag != scope.$eval(attr.drag)
#          console.log "over ", drag
#
#        event.stopPropagation()
#
#
#      element.bind 'mouseover', mousemove
#
#
#
#
#
#}


#@Presentation.directive 'drop', ($document) ->
#
#  restrict: 'A'
#  scope:
#    { canDrop : '@',
#      drop    : '@',
#      dropClass : '@'
#    }
#  link: (scope, element, attr) ->
#
#    scope.$on 'drag', () ->






#@Presentation.directive 'tree', ($compile) -> {
#
#  restrict: 'E',
#  compile: (elem) ->
#
#
#
#    (scope, elem, attrs) ->
#      scope.childHtml = children
#
#      link = $compile children.clone()
#      inner = link scope
#
#      elem.append inner
#      console.log "Link: ", elem, inner
#}
