include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  domain        = "carbon-lattice.com"
  zone_name     = "carbon-lattice.com"
  extra_records = {}
}
