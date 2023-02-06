import * as React from "react";

import { Navbar, Alignment, Button, MenuItem, Menu } from "@blueprintjs/core";
import { Classes, Popover2, MenuItem2 } from "@blueprintjs/popover2";
import { ItemRenderer, Select2 } from "@blueprintjs/select";
import { Link } from "react-router-dom";
import {useAuth} from "react-oidc-context";

export interface Installation {
  host: string;
}

const renderInstallation: ItemRenderer<Installation> = (install, { handleClick, handleFocus, modifiers, query }) => {
  if (!modifiers.matchesPredicate) {
    return null;
  }
  return (
    <MenuItem
      active={modifiers.active}
      disabled={modifiers.disabled}
      key={install.host}
      label={install.host}
      onClick={handleClick}
      onFocus={handleFocus}
      roleStructure="listoption"
    />
  );
};

const InstallSelect: React.FC = () => {
  const [selectedFilm, setSelectedFilm] = React.useState<Installation | undefined>();
  return (
    <Select2<Installation>
      filterable={false}
      items={[{
        host: "launchboxhq.io"
      }]}
      itemRenderer={renderInstallation}
      noResults={<MenuItem disabled={true} text="No results." roleStructure="listoption" />}
      onItemSelect={setSelectedFilm}
      popoverProps={{ minimal: true }}
    >
      <Button text={selectedFilm?.host} rightIcon="double-caret-vertical" placeholder="Select an installation" />
    </Select2>
  );
};

export default function() {
  const auth = useAuth()

  return (
    <Navbar>
      <Navbar.Group align={Alignment.LEFT}>
        <Navbar.Heading>LaunchboxHQ</Navbar.Heading>
        <InstallSelect />
        <Navbar.Divider />
        <Link to="clusters">
          <Button className="bp4-minimal" icon="cargo-ship" text="Clusters"/>
        </Link>
        <Link to="projects">
          <Button className="bp4-minimal" icon="cube" text="Projects"/>
        </Link>
        <Link to="services">
          <Button className="bp4-minimal" icon="git-repo" text="Services"/>
        </Link>
        <Link to="addons">
          <Button className="bp4-minimal" icon="add" text="Addons"/>
        </Link>
        <Link to="catalogs">
          <Button className="bp4-minimal" icon="control" text="Catalogs"/>
        </Link>

      </Navbar.Group>
      <Navbar.Group align={Alignment.RIGHT}>
        <Link to={"Admin"}>
          <Button className={"bp4-minimal"} icon={"home"} text="Admin" />
        </Link>
        <Popover2
          interactionKind="click"
          // popoverClassName={Classes.POPOVER2_CONTENT_SIZING}
          placement="bottom"
          minimal={true}
          content={
            <Menu>
              <MenuItem text={"Profile"} />
              <MenuItem text={"Accounts"} />
              <MenuItem text={"Notifications"} />
              <MenuItem text={"Logout"} onClick={() => void auth.removeUser()}/>
            </Menu>
          }
          renderTarget={({ isOpen, ref, ...targetProps }) => (
            <Button className={"bp4-minimal"} {...targetProps} elementRef={ref} icon="cog" text="Settings" />
          )}
        />
      </Navbar.Group>
    </Navbar>
  )
}