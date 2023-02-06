import * as React from "react"
import { createHashRouter } from "react-router-dom";
import Root from "../root"
import ErrorPage from "./error-page";

import ClusterPages from "../clusters"
import ProjectPages from "../projects"
import CatalogPages from "../catalogs"
import ServicePages from "../services"
import AddonPages from "../addons"

import Client from "../client"

const router = createHashRouter([
  {
    path: "/",
    element: <Root />,
    // errorElement: <ErrorPage />,
    children: [{
      path: "clusters",
      children: [{
        path: "",
        element: <ClusterPages.List />,
        loader: Client.Clusters.list
      }, {
        path: "new",
        element: <ClusterPages.New />
      },{
        path: ":clusterId",
        element: <ClusterPages.View />,
        loader: Client.Clusters.get,
      }]
    }, {
      path: "projects",
      loader: Client.Clusters.list,
      children: [{
        path: "",
        element: <ProjectPages.List />,
        loader: Client.Projects.list
      }, {
        path: "new",
        element: <ProjectPages.New />
      },{
        path: ":projectId",
        element: <ProjectPages.View />,
        loader: Client.Projects.get
      }]
    }, {
      path: "addons",
      children: [{
        path: "",
        element: <AddonPages.List />,
        loader: Client.Projects.list
      }, {
        path: "new",
        element: <AddonPages.New />
      },{
        path: ":addonId",
        element: <AddonPages.View />,
        loader: Client.Projects.get
      }]
    }, {
      path: "catalogs",
      children: [{
        path: "",
        element: <CatalogPages.List />
      }, {
        path: ":catalogId",
        element: <CatalogPages.View />
      }, {
        path: "new",
        element: <CatalogPages.New />
      }]
    }, {
      path: "services",
      children: [{
        path: "",
        element: <ServicePages.List />
      }, {
        path: ":serviceId",
        element: <ServicePages.View />
      }, {
        path: "new",
        element: <ServicePages.New />
      }]
    }]
  }
]);

console.log(router)
export default router