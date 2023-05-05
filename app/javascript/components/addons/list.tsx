import * as React from "react"

import Page from "../common/page"
import {Link} from "react-router-dom";
import {Button} from "@blueprintjs/core";

export default function() {
  return (
    <Page title={"Addons"} primaryAction={
      <Link to={'/addons/new'}>
        <Button text={"New Addon"} intent={"primary"}/>
      </Link>
    }>

    </Page>
  )
}
// Doorkeeper::AccessToken.create!(application_id: nil, resource_owner_id: @user.id, scopes: 'public')