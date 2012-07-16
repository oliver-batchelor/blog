
Article = angular.module('Article', [])

pathArray = (path) -> path.split '.'

@ArticleTools = {}

whenDef = (value, cont) -> if value then cont value

ArticleTools.getNode = (path, content) ->
  pathArr = pathArray path
  node = content

  for n in pathArr
    if node.children && node.children.length > n
      node = node.children[n]
    else
      return undefined

  return node

getNodes = (path, content, type, nodes) ->

  if content.children
    for child, index in content.children

      getNodes path + ".#{index}", child, type, nodes

  if type == undefined || type == content.type
    nodes[path] = content

ArticleTools.getNodes = (content, type) ->
  nodes = {}

  for child, index in content.children
    getNodes index, child, type, nodes

  return nodes

popLast = (path) ->
  last = (path.lastIndexOf '.')
  if last >= 0 then [ parseInt(path.substring last + 1), (path.substring 0, last)] else [parseInt(path), undefined]

popFirst = (path) ->
  first = (path.indexOf '.')
  if first >= 0 then [ parseInt(path.substring 0, first), (path.substring first + 1)] else [parseInt(path), undefined]


pushPath = (path, n) -> if path.length > 0 then "#{path}.#{n}" else "#{n}"

comparePath = (path1, path2) ->
  p1 = pathArray path1
  p2 = pathArray path2

  n = Math.min(p1.length, p2.length) - 1
  for i in [0..n]
    if p1[i] > p2[i]
      return 1

    if p1[i] < p2[i]
      return -1

  if p1.length > p2.length then 1 else (if p1.length < p2.length then -1 else 0)



isType = (node, type) ->  type == undefined || type == node.type


findNode = (node, type, path) ->
  if isType node, type
    return [path, node]

  return findChildren node, type, path


findNodeRev = (node, type, path) ->

  found = findChildrenRev node, type, path
  if found then return found

  if isType node, type
    return [path, node]

findChildren = (node, type, path) ->
  if node.children
    for child, i in node.children

      found = findNode child, type, (pushPath path, i)
      if found then return found

  return undefined

findChildrenRev = (node, type, path) ->
  if node.children
    i = node.children.length - 1

    while (i >= 0)
      child = node.children[i]
      found = findNodeRev child, type, (pushPath path, i)
      if found then return found
      --i

  return undefined

ArticleTools.findNode = (root, type) -> findNode  root, type, ""
ArticleTools.findNodeRev = (root, type) -> findNodeRev  root, type, ""

findNext = (from, node, type, path) ->

  [n, rest] = popFirst from

  if node.children && n < node.children.length
    if rest
      found = findNext rest, node.children[n], type, (pushPath path, n)
    else
      found = findChildren node.children[n], type, (pushPath path, n)

    if found then return found

    if n + 1 < node.children.length
      for i in [n + 1..node.children.length - 1]
        found = findNode node.children[i], type, (pushPath path, i)
        if found then return found

  return undefined

findPrev = (from, node, type, path) ->

  [n, rest] = popFirst from

  if node.children
    n = Math.min node.children.length - 1, n
    if rest
      found = findPrev rest, node.children[n], type, (pushPath path, n)
      if found then return found

    i = n - 1
    while (i >= 0)

      found = findNodeRev node.children[i], type, (pushPath path, i)
      if found then return found
      --i

  if isType node, type then  [path, node] else undefined

ArticleTools.findPrev = (from, root, type) -> findPrev from, root, type, ""
ArticleTools.findNext = (from, root, type) -> findNext from, root, type, ""

#
#ArticleTools.findPrevCont =  (from, root, type) -> findPrev from, root, type, ""

Article.controller 'ArticleCtrl',  ['$scope', (scope) ->

  cursorNode = () -> ArticleTools.getNode scope.editState.cursor.path, scope.content


  scope.moveLeft = () ->
    cursor = scope.editState.cursor

    prevNode = undefined
    whenDef (ArticleTools.findPrev cursor.path, scope.content),  ([path, node]) ->
      prevNode = node

    if cursor.char > 1 || (!(isType prevNode, 'span') && cursor.char > 0)
      cursor.char = cursor.char - 1

    else
      whenDef (ArticleTools.findPrev cursor.path, scope.content, 'span'), ([path, node]) ->
        cursor.path = path
        cursor.char = node.text.length # Off the end



  scope.moveRight = () ->
    cursor = scope.editState.cursor
    span = cursorNode()

    nextNode = undefined

    whenDef (ArticleTools.findNext cursor.path, scope.content),  ([path, node]) ->
      nextNode = node

    if span.text && cursor.char < span.text.length
      cursor.char = cursor.char + 1
    else
      whenDef (ArticleTools.findNext cursor.path, scope.content, 'span'),  ([path, node]) ->

        cursor.path = path
        cursor.char = if nextNode == node then 1 else 0


  scope.editState = {
    cursor: {path: '0.0', char: 1}

  }



]
