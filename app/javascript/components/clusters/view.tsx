import * as React from "react"
import {useLoaderData} from "react-router-dom";

export default function() {
  const cluster = useLoaderData() as any;
  console.log(cluster)
  return (
    <>
      <h3>{ cluster.name }</h3>
    </>
  )
}
