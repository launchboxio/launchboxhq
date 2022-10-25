import * as React from 'react'
import * as ReactDOM from 'react-dom'

const App = () => {
    return (<div>Hello, Rails 7!</div>)
}

document.addEventListener('DOMContentLoaded', () => {
    const rootEl = document.getElementById('app')
    ReactDOM.render(<h1>Hello, from React v2</h1>, rootEl)
})
