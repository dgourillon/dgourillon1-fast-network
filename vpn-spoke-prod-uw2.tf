/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description VPN between landing and production spoke in uw2.

# local.vpn_spoke_bgp_peer_options is defined in the dev VPN file

module "landing-to-prod-uw2-vpn" {
  source           = "./modules/net-vpn-ha"
  project_id       = module.landing-project.project_id
  network          = module.landing-vpc.self_link
  region           = "us-west2"
  name             = "vpn-to-prod-uw2"
  router_create    = true
  router_name      = "landing-vpn-uw2"
  router_asn       = var.router_spoke_configs.landing-uw2.asn
  peer_gcp_gateway = module.prod-to-landing-uw2-vpn.self_link
  tunnels = {
    0 = {
      bgp_peer = {
        address = cidrhost("169.254.0.96/27", 1)
        asn     = var.router_spoke_configs.spoke-prod-uw2.asn
      }
      bgp_peer_options = local.vpn_spoke_bgp_peer_options.landing-uw2
      bgp_session_range = "${
        cidrhost("169.254.0.96/27", 2)
      }/30"
      ike_version                     = 2
      peer_external_gateway_interface = null
      router                          = null
      shared_secret                   = null
      vpn_gateway_interface           = 0
    }
    1 = {
      bgp_peer = {
        address = cidrhost("169.254.0.96/27", 5)
        asn     = var.router_spoke_configs.spoke-prod-uw2.asn
      }
      bgp_peer_options = local.vpn_spoke_bgp_peer_options.landing-uw2
      bgp_session_range = "${
        cidrhost("169.254.0.96/27", 6)
      }/30"
      ike_version                     = 2
      peer_external_gateway_interface = null
      router                          = null
      shared_secret                   = null
      vpn_gateway_interface           = 1
    }
  }
}

module "prod-to-landing-uw2-vpn" {
  source           = "./modules/net-vpn-ha"
  project_id       = module.prod-spoke-project.project_id
  network          = module.prod-spoke-vpc.self_link
  region           = "us-west2"
  name             = "vpn-to-landing-uw2"
  router_create    = true
  router_name      = "prod-spoke-vpn-uw2"
  router_asn       = var.router_spoke_configs.spoke-prod-uw2.asn
  peer_gcp_gateway = module.landing-to-prod-uw2-vpn.self_link
  tunnels = {
    0 = {
      bgp_peer = {
        address = cidrhost("169.254.0.96/27", 2)
        asn     = var.router_spoke_configs.landing-uw2.asn
      }
      bgp_peer_options = local.vpn_spoke_bgp_peer_options.prod-uw2
      bgp_session_range = "${
        cidrhost("169.254.0.96/27", 1)
      }/30"
      ike_version                     = 2
      peer_external_gateway_interface = null
      router                          = null
      shared_secret                   = module.landing-to-prod-uw2-vpn.random_secret
      vpn_gateway_interface           = 0
    }
    1 = {
      bgp_peer = {
        address = cidrhost("169.254.0.96/27", 6)
        asn     = var.router_spoke_configs.landing-uw2.asn
      }
      bgp_peer_options = local.vpn_spoke_bgp_peer_options.prod-uw2
      bgp_session_range = "${
        cidrhost("169.254.0.96/27", 5)
      }/30"
      ike_version                     = 2
      peer_external_gateway_interface = null
      router                          = null
      shared_secret                   = module.landing-to-prod-uw2-vpn.random_secret
      vpn_gateway_interface           = 1
    }
  }
}