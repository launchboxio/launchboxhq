import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import * as React from 'react';
import { Button } from "@blueprintjs/core";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
// Include .css files from vendor
import "@blueprintjs/core/lib/css/blueprint.css";
import "@blueprintjs/datetime2/lib/css/blueprint-datetime2.css";
import "@blueprintjs/datetime/lib/css/blueprint-datetime.css";
import "@blueprintjs/popover2/lib/css/blueprint-popover2.css";
import "@blueprintjs/select/lib/css/blueprint-select.css";
const router = createBrowserRouter([
    {
        path: "/",
        element: _jsxs("div", { children: ["Hello from the index! ", _jsx(Button, { intent: "success", text: "button content" })] })
    },
]);
export default () => (_jsx(React.StrictMode, { children: _jsx(RouterProvider, { router: router }) }));
