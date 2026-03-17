; extends

; nil, blank, and empty are parsed as identifiers in conditional contexts
((identifier) @constant.builtin
  (#any-of? @constant.builtin "nil" "blank" "empty")
  (#set! priority 120))

; Property access — the property field is the accessed name (e.g. `title` in product.title)
(access property: (identifier) @variable.member
  (#set! priority 120))

; Filter named argument keys (e.g. `format` in | date: format: "%b")
(argument key: (identifier) @variable.parameter
  (#set! priority 120))

; Liquid builtin objects → @variable.builtin
((identifier) @variable.builtin
  (#any-of? @variable.builtin
    "forloop"
    "tablerowloop"
    "paginate"
    "cart"
    "product"
    "products"
    "collections"
    "collection"
    "request"
    "settings"
    "shop"
    "customer"
    "order"
    "orders"
    "routes"
    "theme"
    "template"
    "canonical_url"
    "all_products"
    "blogs"
    "block"
    "checkout"
    "content_for_header"
    "content_for_layout"
    "current_page"
    "current_tags"
    "handle"
    "images"
    "linklists"
    "pages"
    "scripts"
    "search"
    "recommendations"
  )
  (#set! priority 120))
