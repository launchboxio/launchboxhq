import * as React from "react"
import { useState } from "react"
import { useNavigate } from "react-router-dom";
import { Card, InputGroup, MenuItem, Button, TextArea } from "@blueprintjs/core"
import { Select2 } from "@blueprintjs/select"
import { Tab, Tabs } from "@blueprintjs/core";

import types from "../types"
import Page from "../common/page"
import Client from "../client"
import toaster from "../toaster"

const initialClusterState = {
  name: "",
  region: "",
  provider: "",
  version: "",
  host: "",
  ca_crt: "",
  token: ""
}

export default function() {
  const [cluster, setCluster] = useState(initialClusterState)
  const [tab, setTab] = useState("managed")
  const navigate = useNavigate();

  const handleTabChange = (selectedTab) => {
    setTab(selectedTab)
  }

  const handleSubmit = async e => {
    e.preventDefault()
    // const managed = (tab === 'managed')
    const res = await Client.Clusters.create( {...cluster } )
    toaster.show({
      message: "Cluster created!",
      intent: "success",
      timeout: 1000
    })
    navigate(`/clusters/${res.data.id}`)
  }

  const managedPanel = (
    <>
      <Select2<any>
        items={types.providers}
        itemRenderer={(provider, { handleClick, handleFocus, modifiers, query }) => {
          return (
            <MenuItem
              active={modifiers.active}
              disabled={modifiers.disabled}
              key={provider.id}
              label={provider.name}
              onClick={handleClick}
              onFocus={handleFocus}
              roleStructure="listoption"
              text={provider.name}
            />
          );
        }}
        noResults={<MenuItem disabled={true} text="No results." roleStructure="listoption" />}
        onItemSelect={(provider) => {
          setCluster({...cluster, provider: provider.id})
        }}
      >
        <Button text={cluster.provider} rightIcon="double-caret-vertical" placeholder="Select a provider" />
      </Select2>
      <Select2<any>
        items={cluster.provider ? types.regions[cluster.provider] : []}
        itemRenderer={(region, { handleClick, handleFocus, modifiers, query }) => {

          return (
            <MenuItem
              active={modifiers.active}
              disabled={modifiers.disabled}
              key={region}
              label={region}
              onClick={handleClick}
              onFocus={handleFocus}
              roleStructure="listoption"
              text={region}
            />
          );
        }}
        noResults={<MenuItem disabled={true} text="No results." roleStructure="listoption" />}
        onItemSelect={(region) => {
          setCluster({...cluster, region})
        }}
      >
        <Button text={cluster.region} rightIcon="double-caret-vertical" placeholder="Select a region" />
      </Select2>
      <InputGroup
        onChange={(e) => setCluster({...cluster, version: e.target.value})}
        placeholder="Version"
        value={cluster.version}
      />
    </>
  )

  const importPanel = (
    <>
      <InputGroup
        onChange={(e) => setCluster({...cluster, host: e.target.value})}
        placeholder="Host"
        value={cluster.host}
      />
      <TextArea
        onChange={(e) => setCluster({...cluster, ca_crt: e.target.value})}
        placeholder="CA Certificate"
        value={cluster.ca_crt}
      />
      <InputGroup
        onChange={(e) => setCluster({...cluster, token: e.target.value})}
        placeholder="Token"
        type={"password"}
        value={cluster.token}
      />
    </>
  )

  return (
    <Page title={"New Cluster"}>
      <Card>
        <InputGroup
          onChange={(e) => setCluster({...cluster, name: e.target.value})}
          placeholder="Cluster name"
          value={cluster.name}
        />
        <Tabs id="TabsExample" onChange={handleTabChange} selectedTabId={tab} renderActiveTabPanelOnly={true}>
          <Tab id="managed" title="Managed" panel={managedPanel} />
          <Tab id="import" title="Import Existing" panel={importPanel} panelClassName="ember-panel" />
          <Tabs.Expander />
        </Tabs>
        <Button intent={"primary"} text={"Create"} onClick={handleSubmit}/>
      </Card>
    </Page>
  )
}

