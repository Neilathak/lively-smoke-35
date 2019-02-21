terraform {
  backend "etcdv3" {
    prefix = "tfstates/ibm/ha-nginx.tfstate."

    endpoints = [
      "https://portal-ssl733-36.bmix-dal-yp-5c0530bf-825b-47c4-abdc-a980be8e7ea8.2398513840.composedb.com:60012",
      "https://portal-ssl772-38.bmix-dal-yp-5c0530bf-825b-47c4-abdc-a980be8e7ea8.2398513840.composedb.com:60012",
    ]
  }
}
