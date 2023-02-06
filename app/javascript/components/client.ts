import axios from 'axios';
import { User } from "oidc-client-ts"

axios.defaults.baseURL = 'http://api.lvh.me:3000';

axios.interceptors.request.use((value: any): any => {
  const oidcStorage = localStorage.getItem(`oidc.user:http://auth.lvh.me:3000:Q3AXCW0w4ckl1w0cmdl2NALnSM91NOibmkspvJBY6HM`)
  if (!oidcStorage) {
    return value;
  }

  const user = User.fromStorageString(oidcStorage)
  if (user.access_token) {
    value.headers.authorization = `Bearer ${user.access_token}`
  }
  return value
})

const Clusters = {
  list: async () => {
    const res = await axios.get("/v1/clusters")
    return res.data
  },
  get: async ({ params }) => {
    const res = await axios.get(`/v1/clusters/${params.clusterId}`)
    return res.data
  },
  create: async(data) => {
    return await axios.post('/v1/clusters', { cluster: data } )
  }
}

const Projects = {
  list: async () => {
    const res = await axios.get("/v1/projects")
    return res.data
  },
  get: async ({ params }) => {
    return await axios.get(`/v1/projects/${params.projectId}`)
  },
  create: async(clusterId, project) => {
    return await axios.post('/v1/projects', { project, cluster_id: clusterId } )
  }
}

const Addons = {
  list: async () => {
    const res = await axios.get("/v1/addons")
    return res.data
  },
  get: async ({ params }) => {
    return await axios.get(`/v1/addons/${params.addonId}`)
  },
  create: async(data) => {
    return await axios.post('/v1/addons', { addon: data } )
  }
}

export default {
  Clusters,
  Projects,
  Addons
}