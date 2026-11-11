include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  after_hook "nixie" {
    commands    = ["apply"]
    working_dir = "${get_working_dir()}/flake"
    execute = [
      "sudo", run_cmd("--terragrunt-global-cache", "--terragrunt-quiet", "sh", "-c", "command -v nixie"),
      "--installer", "path:.#nixosConfigurations.installer",
      "--flake", "path:.",
      "--hosts", "hosts.json",
      # Nixie auto-detects the first interface address; pin it to the controller's LAN address (empty = auto).
      "--address", get_env("NIXIE_ADDRESS", ""),
    ]
  }
}

inputs = {
  hosts   = jsondecode(file("${get_terragrunt_dir()}/hosts.json"))
  cluster = jsondecode(file("${get_terragrunt_dir()}/../cluster/config.json"))
}
