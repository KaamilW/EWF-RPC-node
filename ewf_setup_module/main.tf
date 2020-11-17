locals {
    conditionMap = {
        "test" = "volta"
        "prod" = "ewc"
    }
    backup_name = var.environment_name == "test" ? "volta" : "ewc_chain"
    chain_name = var.environment_name == "test" ? "Volta" : "EnergyWebChain"
    installation_script = templatefile("${path.module}/scripts/ewf_rpc_node_setup.sh", {environment = lookup(local.conditionMap, var.environment_name, "volta")})
    backup_script = var.load_backup == true ? templatefile("${path.module}/scripts/ewf_rpc_node_backup.sh", {chain = local.chain_name, backup_file = local.backup_name, backup_link = var.backup_link}) : ""
}

