import {REMOVE_NOTIFICATION,
        PUT_NOTIFICATION,
        SET_CURRENT_RESOURCES,
        UPDATE_AR_FIELD,
        UPDATE_AR_MAP,
        SET_AR_API,
        ACTIVE_RESOURCE,
        RECEIVE_ALL,
        RECEIVE_ONE,
        REMOVE_RESOURCE,
        UPDATE_RESOURCE} from "./mutation_types"

import { wrap_raw_resource, page_like, project } from "../resources"

export const remove_notification = ({dispatch}, notification) => {
  dispatch(REMOVE_NOTIFICATION, notification)
}

export const notify = ({dispatch}, notification) => {
  dispatch(PUT_NOTIFICATION, notification)

  if(notification.timeout){
    setTimeout(() => {
      dispatch(REMOVE_NOTIFICATION, notification)
    }, notification.timeout)
  }
}

export const set_current_resources = ({dispatch}, r) => {
  dispatch(SET_CURRENT_RESOURCES, r)
}
export const add_resource = ({dispatch}, r) => {
  dispatch(RECEIVE_ONE, r)
}
export const update_resource = ({dispatch}, key, r) => {
  dispatch(UPDATE_RESOURCE, key, r)
}
export const set_active = ({dispatch}, r) => {
  dispatch(ACTIVE_RESOURCE, r)
}
export const update_ar_field = ({dispatch}, field, new_value) => {
  dispatch(UPDATE_AR_FIELD, {field, new_value})
}
export const update_ar_map = ({dispatch}, map, key, value) => {
  dispatch(UPDATE_AR_MAP, map, key, value)
}

export const set_ar_api = ({dispatch}, api) => {
  dispatch(SET_AR_API, api)
}

export const fetch_resources = ({dispatch, state}, opts) => {
  state.resources.api.get()
    .then((resp) => {
      let wrapped = resp.json().data.map((r) => {
        return wrap_raw_resource(r, classify(r), false)
      })
        // FIXME
        // ensure to show current path resource
      if (opts && opts.id) {
        let res = wrapped.find(r => r.id == opts.id)
        dispatch(ACTIVE_RESOURCE, res)
      } else {
        dispatch(ACTIVE_RESOURCE, null)
      }

      dispatch(RECEIVE_ALL, wrapped)
    })
}

export const save_ar = ({dispatch, state}, opts) => {
  let rs = state.resources
  rs.api.save({[rs.api.name]: rs.active_resource})
    .then((resp) => {
      let r = resp.json().data
      let data = wrap_raw_resource(r, classify(r), false)

      notify({dispatch}, crud_notification(
        "success",
        `${rs.api.name} was saved successfully.`,
        1000,
        resp
      ))

      let oldKey = rs.active_resource.id

      // replace temp route with real id from the server
      if (opts && opts.router) {
        opts.router.replace(data.id.toString())
      }

      dispatch(UPDATE_RESOURCE, oldKey, data)
      dispatch(ACTIVE_RESOURCE, data)
    })
    .catch((resp) => {
      let errors = resp.json().errors
      let formatted_errors = Object.keys(errors).map((field) => {
        return `${field} ${errors[field]}`
      })
      notify({dispatch}, crud_notification(
        "error",
        formatted_errors || `Error saving ${rs.api.name}`,
        null,
        resp
      ))
    })
}
export const update_ar = ({dispatch, state}) => {
  let rs = state.resources
  rs.api.update({id: rs.active_resource.id}, {[rs.api.name]: rs.active_resource})
    .then((resp) => {
      let r = resp.json().data
      let data = wrap_raw_resource(r, classify(r), false)

      notify({dispatch}, crud_notification(
        "success",
        `${rs.api.name} was updated successfully.`,
        1500,
        resp
      ))

      let oldKey = rs.active_resource.id
      dispatch(UPDATE_RESOURCE, oldKey, data)
      dispatch(ACTIVE_RESOURCE, data)
    })
}

export const delete_ar = ({dispatch, state}) => {
  let r = state.resources
  r.api.delete({id: r.active_resource.id})
    .then((resp) => {
      notify({dispatch}, crud_notification(
        "success",
        `${r.api.name} was deleted successfully.`,
        3000,
        resp))
      dispatch(REMOVE_RESOURCE, r.active_resource.id)
    })
    .catch((resp) => {
      notify({dispatch}, crud_notification(
        "error",
        `Error deleting ${r.api.name}`,
        resp
      ))
    })
}

function crud_notification(type, msg, timeout, resp) {
  return {
    type,
    msg,
    timeout: timeout > 0 ? timeout : null,
    resp
  }
}

function classify(r) {
  if (r.hasOwnProperty("html") || r.hasOwnProperty("markdown")) {
    return page_like
  } else {
    return project
  }
}

