export const wrap_raw_resource = (r, proto, is_new) => {
  let o = Object.assign({}, proto)
  o = Object.assign(o, r)

  if (r.published_at) {
    o.published = true
    o.published_at = new Date(r.published_at)
    .toDateString()
  }
  if (is_new) {
    o.id = `new${new Date().getTime()}`
  }
  return o
}

export const page_like = {
  html: "",
  markdown: "",
  link: "",
  title: "",
  published: null,
  editor: "ResourceMarkdownEditor"
}

export const project = {
  links: {},
  name: "",
  desc: "",
  status: "",
  editor: "ProjectEditor"
}

export const menu = build_menu()

function build_menu() {
  const menu_entries = {
    "notes": ["manage"],
    "pages": ["manage"],
    "projects": ["manage"]
  }

  let menu = {}
  let keys = Object.keys(menu_entries)

  keys.forEach((key) => {
    let km = build_resource_menu(key, menu_entries[key])
    menu[key] = { name: key, actions: km }
  })

  return menu
}

function build_resource_menu(resource, actions) {
  let rm = []
  actions.forEach((action) => {
    let new_entry = {
      name: action,
      link: `/${action}/${resource}`
    }
    rm.push(new_entry)
  })
  return rm
}


