import * as React from "react"
import Break from "./break";
import styled from "styled-components"

interface IPageProps {
  children: any,
  title: string,
  primaryAction?: any
  secondaryAction?: any
}

const Header = styled.h2`
  font-size: 29px;
  font-weight: lighter;
  display: inline-block;
  margin:0;
  margin-right: 42px;`

const Actions = styled.div`
  margin-left: auto;
`

export default (props : IPageProps) => {
  let actions = (
    <Actions>
      { props.secondaryAction }
      { props.primaryAction }
    </Actions>
  )
  return (
    <div style={{
      display: "flex",
      flexWrap: "wrap",
      gap: "10px",
      padding: "10px",
      width: "100%"
    }}>
      <Header>{ props.title }</Header>
      {actions}
      <Break />
      { props.children }
    </div>
  )
}