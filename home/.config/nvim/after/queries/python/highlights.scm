;; put *just* the keywords in @include so they inherit italics
(import_statement
  "import" @include)

(import_from_statement
  [
    "from"
    "import"
  ] @include)


(import_statement
  name: (dotted_name (identifier) @import.module))

(import_statement
  name: (aliased_import
          name: (dotted_name (identifier) @import.module)
          alias: (identifier)               @import.module))

;;   from typing import Any, Optional ...
(import_from_statement
  (_
    (aliased_import
      name: (dotted_name (identifier)       @import.module)
      alias: (identifier)                   @import.module))
  )

(import_from_statement
  (_
    (dotted_name (identifier)               @import.module))
  )
