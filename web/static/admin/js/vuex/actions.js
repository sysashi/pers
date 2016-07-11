export const remove_notification = ({dispatch}, notification) => {
  dispatch("REMOVE_NOTIFICATION", notification)
}
export const notify = ({dispatch}, notification) => {
  dispatch("PUT_NOTIFICATION", notification)
    if(notification.timeout){
      setTimeout(() => {
        dispatch("REMOVE_NOTIFICATION", notification)
      }, notification.timeout)
    }
}

