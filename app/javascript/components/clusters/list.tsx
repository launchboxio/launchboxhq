import * as React from "react"
import { Card, Elevation, Button } from "@blueprintjs/core"
import { Link, useLoaderData } from "react-router-dom"

import Page from "../common/page"

export default function() {
  const clusters = useLoaderData() as any;
  let content
  if (clusters?.length == 0) {
    content = (
      <Card>
        <p>There aren't any configured clusters yet</p>
        <Link to={"/clusters/new"}>
          <Button text={"Create a cluster"} intent={"primary"}/>
        </Link>
      </Card>
    )
  } else {
    content = clusters?.map((item) => {
      return (
        <div>
          <Card interactive={true} key={ item.id } elevation={Elevation.TWO}>
            <h5><Link to={`/clusters/${ item.id }`}>{ item.name }</Link></h5>
            <Button>Submit</Button>
          </Card>
        </div>
      )
    })
  }

  return (
    <Page title={"Clusters"} primaryAction={
      <Link to={'/clusters/new'}>
        <Button text={"New Cluster"} intent={"primary"}/>
      </Link>
    }>
      {content}
    </Page>
  )
}
