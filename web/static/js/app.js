// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".

import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".
//
// import socket from "./socket"
import tinycolor from "tinycolor2"

const card_color_attr = "data-base-color"

function colorify_project_cards() {
  // let style = document.createElement("style")
  // document.head.appendChild(style)

  let class_selector = "project-card"
  let elements = document.getElementsByClassName(class_selector)

  Array.from(elements).forEach(elem => {
    //let rules = colorscheme(elem)
    //insertRules(style.sheet, rules)
    colorscheme(elem)
  })
}

// .project-card > .project-info(border) > .name(bg, border)
// TODO
function colorscheme(card) {
  let card_color = card.getAttribute(card_color_attr)

  if (!card_color) {
      return
  }

  let color = tinycolor(card_color)
  // let colorscheme = gen_colorscheme(color)
  // card.classList.add("card-colorscheme-1")

  let [info_block] = card.getElementsByClassName("project-info")
  let [name_block] = info_block.getElementsByClassName("name")

  info_block.style.border = `1px solid ${color.darken(10)}`
  name_block.style.background = `${color.lighten(10)}`
  name_block.style.borderBottom = `1px solid ${color.darken(20)}`

  // return colorscheme
}

// function gen_colorscheme(color) {
//   let rule1 = `.card-colorscheme-1 > .project-info {border-color: ${color}}`
//   let rule2 = ".card-colorscheme-1 .name {background: #000; border-color: #FFF}"
//   return [rule1, rule2]
// }
// 
// function insertRules(sheet, rules) {
//   return rules.forEach(rule => sheet.insertRule(rule, sheet.cssRules.length))
// }

colorify_project_cards()
