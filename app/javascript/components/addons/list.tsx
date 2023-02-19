import * as React from "react"

import Page from "../common/page";
import {Link, useLoaderData} from "react-router-dom";
import {Button, Card, Elevation} from "@blueprintjs/core";

export default function() {
  const addons = useLoaderData() as any;
  let content
  if (addons?.length == 0) {
    content = (
      <Card>
        <p>You don't have any addons yet</p>
        <Link to={"/addons/new"}>
          <Button text={"Create an addon"} />
        </Link>
      </Card>
    )
  } else {
    content = addons?.map((item) => {
      return (
        <div>
          <Card interactive={true} key={ item.id } elevation={Elevation.TWO}>
            <h5><Link to={`/addons/${ item.id }`}>{ item.name }</Link></h5>
          </Card>
        </div>
      )
    })
  }
  return (
    <Page title={"Addons"} primaryAction={
      <Link to={'/addons/new'}>
        <Button text={"New Addon"} intent={"primary"}/>
      </Link>
    }>
      {content}
    </Page>
  )
}