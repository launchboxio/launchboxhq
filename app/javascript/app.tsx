import * as React from 'react'
import * as ReactDOM from 'react-dom'
import { Button } from "@blueprintjs/core";
import {
    createBrowserRouter,
    RouterProvider,
    Route
} from "react-router-dom";

// Include .css files from vendor
import "@blueprintjs/core/lib/css/blueprint.css"
import "@blueprintjs/datetime2/lib/css/blueprint-datetime2.css";
import "@blueprintjs/datetime/lib/css/blueprint-datetime.css";
import "@blueprintjs/popover2/lib/css/blueprint-popover2.css";
import "@blueprintjs/select/lib/css/blueprint-select.css";

const router = createBrowserRouter([
    {
        path: "/",
        element: <div>Hello from the index! <Button intent="success" text="button content"/></div>
    },
])

export default () => (
    <React.StrictMode>
        <RouterProvider router={router} />
    </React.StrictMode>
)