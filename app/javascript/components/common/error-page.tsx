import * as React from "react"
import {Link, useRouteError} from "react-router-dom";
import {Button} from "@blueprintjs/core";

export default function ErrorPage() {
  const error = useRouteError() as any;
  console.error(error);

  return (
    <div id="error-page">
      <h1>Oops!</h1>
      <p>Sorry, an unexpected error has occurred.</p>
      <p>
        <i>{error.statusText || error.message}</i>
      </p>
      <Link to="/">
        Home
      </Link>
    </div>
  );
}