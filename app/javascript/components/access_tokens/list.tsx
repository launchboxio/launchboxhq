import * as React from "react"

import Page from "../common/page"
import { Button } from "@blueprintjs/core"

export default function() {
  return (
    <Page title={"Access Tokens"} primaryAction={
      <Button text={"New Token"} intent={"primary"} />
    }>

    </Page>
  )
}