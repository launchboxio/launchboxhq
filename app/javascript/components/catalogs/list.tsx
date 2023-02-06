import * as React from "react"

const data = {
  catalogs: []
}
import { Card, Elevation, Button } from "@blueprintjs/core"
import { Link } from "react-router-dom"
import Page from "../common/page"

export default function() {

  return (
    <Page title={"Catalogs"} primaryAction={
      <Link to={'/catalogs/new'}>
        <Button text={"New Catalog"} intent={"primary"}/>
      </Link>
    }>
      {data.catalogs.map((item) => {
        return (
          <div>
            <Card interactive={true} key={ item.id } elevation={Elevation.TWO}>
              <h5><Link to={`/catalogs/${ item.id }`}>{ item.id }</Link></h5>
            </Card>
          </div>
        )
      })}
    </Page>
  )
}
