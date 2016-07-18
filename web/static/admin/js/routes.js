import ResourceCrudView from "./components/resource_crud_view"
import MarkdownEditor from "./components/editor"
import ProjectEditor from "./components/project_editor"

export default {
  "/manage/projects": {
    name: "ProjectsCrudView",
    custom_param: "projects",
    component: ResourceCrudView,
    subRoutes: {
      "/:id": {
        name: "ProjectEditor",
        component: ProjectEditor
      }
    }
  },
  "/manage/:resource": {
    name: "ResourceCrudView",
    component: ResourceCrudView,
    subRoutes: {
      "/:id": {
        name: "ResourceMarkdownEditor",
        component: MarkdownEditor
      }
    }
  }
}
