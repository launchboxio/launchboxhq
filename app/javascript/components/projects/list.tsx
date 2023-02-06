import * as React from "react"
import { Card, Elevation, Button, H5 } from "@blueprintjs/core"
import { Link, useLoaderData } from "react-router-dom"

import Page from "../common/page"

import {
  LineChart,
  XAxis,
  YAxis,
  CartesianGrid,
  Line,
  ResponsiveContainer,
  Tooltip
} from "recharts";

const metrics = [];

export default function() {
  const projects = useLoaderData() as any
  let content = (
    <Card>
      <p>There aren't any configured projects yet</p>
      <Link to={"/projects/new"}>
        <Button text={"Create a project"}/>
      </Link>
    </Card>
  )
  if (projects?.length > 0) {
    content = projects.map((item) => {
      let projectState
      if (item.state == "running") {
        projectState = <Button text={"Running"} icon={"play"} />
      } else if (item.state == "paused") {
        projectState = <Button text={"Paused"} icon={"pause"} />
      }
      return (
        <div style={{flexBasis: "100%"}}>
          <Card interactive={true} key={ item.id } elevation={Elevation.TWO}>
            <div style={{

            }}>
              <H5>
                <Link to={`/projects/${ item.id }`}>{ item.name }</Link>
                <div style={{ marginLeft: "auto"}}>
                  {projectState}
                </div>
              </H5>
            </div>
            <div style={{display: "flex"}}>
              <ResponsiveContainer height={100}>
                <LineChart
                  width={100}
                  height={100}
                  data={metrics}
                  syncId="anyId"
                  title={"CPU"}
                  margin={{
                    top: 10,
                    right: 30,
                    left: 0,
                    bottom: 0,
                  }}
                >
                  <XAxis/>
                  <YAxis />
                  <Tooltip />
                  <Line type="monotone" dataKey="uv" stroke="#8884d8" fill="#8884d8" />
                </LineChart>
              </ResponsiveContainer>
              <ResponsiveContainer height={100}>
                <LineChart
                  width={100}
                  height={100}
                  title={"Memory"}
                  data={metrics}
                  syncId="anyId"
                  margin={{
                    top: 10,
                    right: 30,
                    left: 0,
                    bottom: 0,
                  }}
                >
                  <XAxis/>
                  <YAxis />
                  <Tooltip />
                  <Line type="monotone" dataKey="uv" stroke="#8884d8" fill="#8884d8" />
                </LineChart>
              </ResponsiveContainer>
              <ResponsiveContainer height={100}>
                <LineChart
                  width={100}
                  height={100}
                  title={"Disk"}
                  data={metrics}
                  syncId="anyId"
                  margin={{
                    top: 10,
                    right: 30,
                    left: 0,
                    bottom: 0,
                  }}
                >
                  <XAxis/>
                  <YAxis />
                  <Tooltip />
                  <Line type="monotone" dataKey="uv" stroke="#8884d8" fill="#8884d8" />
                </LineChart>
              </ResponsiveContainer>
            </div>
            <Button>Submit</Button>
          </Card>
        </div>
      )
    })
  }
  return (
    <Page title={"Projects"} primaryAction={
      <Link to={'/projects/new'}>
        <Button text={"New Project"} intent={"primary"}/>
      </Link>
    }>
      {content}
    </Page>
  )
}