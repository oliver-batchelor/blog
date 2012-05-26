# Leave out forEach arguments
partial = (func, a...) ->
  (b...) -> func a..., b...

