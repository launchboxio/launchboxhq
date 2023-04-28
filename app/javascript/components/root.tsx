import * as React from "react"
import Navbar from "./common/navbar";
import { Outlet, useNavigation } from "react-router-dom";
import { hasAuthParams, useAuth } from "react-oidc-context";
import { AuthProvider } from "react-oidc-context";
import {User, WebStorageStateStore} from "oidc-client-ts";
import { Spinner } from "@blueprintjs/core";

const oidcConfig = {
  authority: "http://auth.lvh.me:3000",
  client_id: "Q3AXCW0w4ckl1w0cmdl2NALnSM91NOibmkspvJBY6HM",
  redirect_uri: "http://app.lvh.me:3000",
  scope: "openid manage_clusters manage_projects",
  userStore: new WebStorageStateStore({
    store: localStorage
  }),
}

const AutomaticRedirect = (props: any) => {
  const auth = useAuth();

  // automatically sign-in
  React.useEffect(() => {
    console.log(hasAuthParams())
    console.log(auth)
    if (!hasAuthParams() &&
      !auth.isAuthenticated && !auth.activeNavigator && !auth.isLoading) {
      auth.signinRedirect();
    }
  }, [auth.isAuthenticated, auth.activeNavigator, auth.isLoading, auth.signinRedirect]);

  if(auth.activeNavigator) {
    return <div>Signing you in/out...</div>;
  }
  if (!auth.isAuthenticated) {
    return <div>Unable to log in</div>;
  }

  return props.children;
}

export default function () {
  const navigation = useNavigation();
  const onSigninCallback = (_user: User | void): void => {
    window.history.replaceState(
      {},
      document.title,
      window.location.pathname
    )
  }
  return (
    <>
      <AuthProvider {...oidcConfig} onSigninCallback={onSigninCallback}>
        <AutomaticRedirect>
          <Navbar />
          <div style={{ display: "flex"}}>
            {navigation.state === 'loading' ? <Spinner
              intent={"primary"}
              size={50}
              value={null}
            /> : <Outlet />}
          </div>
        </AutomaticRedirect>
      </AuthProvider>
    </>
  )
}