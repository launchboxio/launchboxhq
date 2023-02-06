import * as React from "react"
import {useLoaderData} from "react-router-dom";

const data = {
  projects: []
}

export async function loader({ params }: any) {
  return data.projects.find((item: any) => item.id == params.projectId)
}

export default function() {
  const project = useLoaderData() as any
  return (
    <>
      <h3>Viewing a project</h3>
      <h4>{ project.name }</h4>
    </>
  )
}