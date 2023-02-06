const providers = [
  { id: "aws", name: "AWS"},
  { id: "gcp", name: "Google"},
  { id: "azure", name: "Azure"},
  { id: "lbx", name: "Launchbox"},
  { id: "digitalocean", name: "Digital Ocean"}
]
const regions = {
  aws: [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2"
  ]
}

export default {
  providers,
  regions
}