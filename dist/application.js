import { jsx as _jsx } from "react/jsx-runtime";
import * as React from 'react';
import * as ReactDOM from 'react-dom';
import App from "./app";
document.addEventListener('DOMContentLoaded', () => {
    const rootEl = document.getElementById('app');
    ReactDOM.render(_jsx(App, {}), rootEl);
});
