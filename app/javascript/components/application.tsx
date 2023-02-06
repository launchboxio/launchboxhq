import * as React from "react";
import * as ReactDOM from "react-dom";

import Router from "./common/router";
import {RouterProvider} from "react-router-dom";

import "normalize.css";
import "@popperjs/core/lib/popper.js";
import "@blueprintjs/core/lib/css/blueprint.css";
// import "@blueprintjs/icons/lib/css/blueprint-icons.css";
import "@blueprintjs/popover2/lib/css/blueprint-popover2.css";
import "@blueprintjs/select/lib/css/blueprint-select.css";

interface AppProps {
    arg: string;
}

const App = ({ arg }: AppProps) => {
    return <RouterProvider router={Router} />
};


document.addEventListener("DOMContentLoaded", () => {
    const rootEl = document.getElementById("root");
    ReactDOM.render(<App arg="Rails 7 with ESBuild" />, rootEl);
});