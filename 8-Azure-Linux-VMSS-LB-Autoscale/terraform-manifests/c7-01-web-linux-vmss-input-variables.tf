variable "web_vmss_inbound_ports" {
  description = "Inbound ports for vmss"
  type        = map(string)
  default     = {
    "100" : "80",
    "110" : "443",
    "130" : "22",
  }
}
