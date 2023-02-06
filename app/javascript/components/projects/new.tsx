import * as React from "react"
import { useState } from "react"
import {useNavigate} from "react-router-dom";
import { Card, InputGroup, MenuItem, Button, TextArea } from "@blueprintjs/core"
import { Select2 } from "@blueprintjs/select"
import { Tab, Tabs } from "@blueprintjs/core";

import Page from "../common/page"
import Client from "../client";
import toaster from "../toaster";

const initialProductState = {
  name: "",
  memory: "",
  cpu: "",
  disk: "",
}
export default function() {
  const [cluster, setCluster] = useState(7)
  const [project, setProject] = useState(initialProductState)
  const navigate = useNavigate();

  const handleSubmit = async e => {
    e.preventDefault()
    const res = await Client.Projects.create( cluster, project )
    toaster.show({
      message: "Project created!",
      intent: "success",
      timeout: 1000
    })
    navigate(`/projects/${res.data.id}`)
  }
  return (
    <Page title={"New Project"} primaryAction={<Button
      intent={"primary"}
      text={"Create"}
      onClick={handleSubmit}
    />}>
      <InputGroup
        onChange={(e) => setProject({...project, name: e.target.value})}
        placeholder="Name"
        value={project.name}
      />
      <InputGroup
        onChange={(e) => setProject({...project, memory: e.target.value})}
        placeholder="Memory"
        value={project.memory}
      />
      <InputGroup
        onChange={(e) => setProject({...project, cpu: e.target.value})}
        placeholder="CPU"
        value={project.cpu}
      />
      <InputGroup
        onChange={(e) => setProject({...project, disk: e.target.value})}
        placeholder="Disk"
        value={project.disk}
      />

    </Page>
  )
}