;; only match calls whose method name is "require" or "include"
(call
  method: (identifier) @include
  (#match? @include "^(require|include)$")
)

;; bold the first string arg of `require`
(call
  method: (identifier) @_id
  arguments: (argument_list
    (string
      (string_content) @import.module))
  (#eq? @_id "require"))
