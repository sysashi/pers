import ResourceCrudView from "./components/resource_crud_view"
import Editor from "./components/editor"

export default {
  "/manage/:resource": {
    name: "ResourceCrudView",
    component: ResourceCrudView,
    subRoutes: {
      "/:id": {
        name: "ResourceMarkdownEditor",
        component: Editor
      }
    }
  }
}
