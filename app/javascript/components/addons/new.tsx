import * as React from "react";
import { useState } from "react";

import Page from "../common/page";
import {Button, Checkbox, InputGroup} from "@blueprintjs/core";
import {useNavigate} from "react-router-dom";
import Client from "../client";
import * as cluster from "cluster";
import toaster from "../toaster";
import AceEditor from "react-ace";
import "ace-builds/src-noconflict/mode-yaml";

export default function() {
  const [name, setName] = useState("")
  const [clusterAttachable, setClusterAttachable] = useState(false)
  const [projectAttachable, setProjectAttachable] = useState(true)
  const [definition, setDefinition] = useState("")
  const [jsonSchema, setJsonSchema] = useState("")
  const [mapping, setMapping] = useState("")

  const navigate = useNavigate()

  const handleSubmit = async e => {
    e.preventDefault()
    const res = await Client.Addons.create({
      name,
      cluster_attachable: clusterAttachable,
      project_attachable: projectAttachable,
      definition,
      json_schema: jsonSchema,
      mapping
    })
    console.log(res)
    toaster.show({
      message: "Addon created!",
      intent: "success",
      timeout: 1000
    })
    navigate(`/addons/${res.data.id}`)
  }

  return (
    <Page title={"New Addon"} primaryAction={
      <Button intent={"primary"} text={"Create"} onClick={handleSubmit}/>
    }>
      <InputGroup
        onChange={(e) => setName(e.target.value)}
        placeholder="Name"
        value={name}
      />
      <Checkbox checked={clusterAttachable} label="Can attach to clusters" onChange={(e) => {
        setClusterAttachable((e.target as HTMLInputElement).checked)
      }} />
      <Checkbox checked={projectAttachable} label="Can attach to projects" onChange={(e) => {
        setProjectAttachable((e.target as HTMLInputElement).checked)
      }} />
      <AceEditor
        mode="yaml"
        theme="github"
        onChange={setDefinition}
        name="definition"
      />
      <AceEditor
        mode="json"
        theme="github"
        onChange={setJsonSchema}
        name="json_schema"
      />
      <AceEditor
        mode="json"
        theme="github"
        onChange={setMapping}
        name="mapping"
      />
    </Page>
  )
}