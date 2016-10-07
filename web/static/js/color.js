export const Color = {verify_color_format, parse_color}

function verify_color_format(color) {
  let regex = /^#?([A-Fa-f0-9]{3,4}){1,2}$/
  if (!regex.test(color)) {
    return {error: `invalid color: ${color}`}
  }

  return {color: color}
}

function parse_color({color, error}) {
  if (error) {
      return error
  } 
}
