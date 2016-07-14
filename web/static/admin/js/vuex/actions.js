import {REMOVE_NOTIFICATION,
        PUT_NOTIFICATION,
        SET_CURRENT_RESOURCES,
        UPDATE_AR_FIELD,
        SET_AR_API,
        ACTIVE_RESOURCE,
        RECEIVE_ALL,
        RECEIVE_ONE,
        REMOVE_RESOURCE,
        CLEAR_ALL,
        UPDATE_RESOURCE} from "./mutation_types"

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
export const fetch_resources = ({dispatch, state}) => {
  let r = state.resources
  state.resources.api.get()
    .then((resp) => {
        let wrapped = resp.json().data.map((r) => {
          return wrap_raw_resource(r)
        })
        // FIXME
        dispatch(ACTIVE_RESOURCE, null)
        // dispatch(CLEAR_ALL)
        dispatch(RECEIVE_ALL, wrapped)
    })
    .catch((resp) => {
      notify({dispatch}, crud_notification(
        "error",
        `Error fetching ${r.api.name}s`,
        null,
        resp
      ))
    })
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

export const set_ar_api = ({dispatch}, api) => {
  dispatch(SET_AR_API, api)
}

export const save_ar = ({dispatch, state}) => {
  let r = state.resources
  r.api.save({[r.api.name]: r.active_resource})
    .then((resp) => {
      let data = wrap_raw_resource(resp.json().data)
      notify({dispatch}, crud_notification(
        "success",
        `${r.api.name} was saved successfully.`,
        1000,
        resp))
      let oldKey = r.active_resource.id
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
        formatted_errors || `Error saving ${r.api.name}`,
        null,
        resp
      ))
    })
}
export const update_ar = ({dispatch, state, watch}) => {
  console.log("ACTION UPDATE ACTIVE_RESOURCE")
  let r = state.resources
  r.api.update({id: r.active_resource.id}, {[r.api.name]: r.active_resource})
    .then((resp) => {
      let data = wrap_raw_resource(resp.json().data)
      notify({dispatch}, crud_notification(
        "success",
        `${r.api.name} was updated successfully.`,
        1500,
        resp))
        let oldKey = r.active_resource.id
        dispatch(UPDATE_RESOURCE, oldKey, data)
        set_active({dispatch}, data)
    })
    .catch((resp) => {
      notify({dispatch}, crud_notification(
        "error",
        `Error updating ${r.api.name}`,
        resp
      ))
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

const editable_r = {
  html: "",
  markdown: "",
  link: "",
  title: "",
  published: false,
}
function wrap_raw_resource(r) {
  let o = Object.assign({}, editable_r)
  o = Object.assign(o, r)
  if (r.published_at) { 
    o.published = true 
    o.published_at = new Date(r.published_at)
    .toDateString()
  }
  return o
}
