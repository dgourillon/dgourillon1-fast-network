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


variable "router_spoke_configs" {
  description = "Configurations for routers used for internal connectivity."
  type = map(object({
    adv = object({
      custom  = list(string)
      default = bool
    })
    asn = number
  }))
  default = {
    landing-uc1    = { asn = "64512", adv = null }
    landing-uw2    = { asn = "64512", adv = null }
    spoke-dev-uc1  = { asn = "64513", adv = null }
    spoke-dev-uw2  = { asn = "64513", adv = null }
    spoke-prod-uc1 = { asn = "64514", adv = null }
    spoke-prod-uw2 = { asn = "64514", adv = null }
  }
}

variable "vpn_spoke_configs" {
  description = "VPN gateway configuration for spokes."
  type = map(object({
    default = bool
    custom  = list(string)
  }))
  default = {
    landing-uc1 = {
      default = false
      custom  = ["rfc_1918_10", "rfc_1918_172", "rfc_1918_192"]
    }
    landing-uw2 = {
      default = false
      custom  = ["rfc_1918_10", "rfc_1918_172", "rfc_1918_192"]
    }
    dev-uc1 = {
      default = false
      custom  = ["gcp_dev"]
    }
    prod-uc1 = {
      default = false
      custom  = ["gcp_prod"]
    }
    prod-uw2 = {
      default = false
      custom  = ["gcp_prod"]
    }
  }
}
