import ContentManager from "./components/content_manager"
import ResourceCrudView from "./components/resource_crud_view"
export default {
  "/manage/:resource": {
    name: "ResourceCrudView",
    component: ResourceCrudView 
  }
}
