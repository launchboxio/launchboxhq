import * as React from 'react'
import * as ReactDOM from 'react-dom'
import App from "./app";

document.addEventListener('DOMContentLoaded', () => {
    const rootEl = document.getElementById('app')
    ReactDOM.render(<App />, rootEl)
})
