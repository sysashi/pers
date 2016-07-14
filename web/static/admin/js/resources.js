import Vue from "vue" 

const api_url = "http://admin.localhost:4000/api/"
export const APIURL = api_url 

let resources = ["pages", "notes", "projects", "logs"]

let menu_entries = {
  "notes": ["manage"],
  "pages": ["manage"],
  "projects": ["manage"]
}

function build_menu(entries) {
  let menu = {}
  let keys = Object.keys(entries)
  keys.forEach((key) => {
    let km = build_resource_menu(key, entries[key])
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

export const menu = build_menu(menu_entries)

