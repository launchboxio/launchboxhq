import * as React from "react"
// import data from "../data/services.json"
const data = {
  services: []
}
import { Card, Elevation, Button } from "@blueprintjs/core"
import { Link } from "react-router-dom"

import Page from "../common/page"
import Break from "../common/break"
export default function() {

  return (
    <Page title={"Services"} primaryAction={
      <Link to={'/services/new'}>
        <Button text={"New Service"} intent={"primary"}/>
      </Link>
    }>
      {data.services.map((item) => {
        return (
          <div style={{flexBasis: "100%"}}>
            <Card interactive={true} elevation={Elevation.TWO}>
              <h5>{ item.host }</h5>
              <p>Card content</p>
              <Button>Submit</Button>
            </Card>
          </div>

        )
      })}
    </Page>
  )
}
