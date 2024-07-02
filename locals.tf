locals {

  tags            = merge(var.tags, { module_name = "tf-module-vpc" })
  vpc_tags        = merge(local.tags, { Name = "${var.env}-vpc" })
  web_subnet_tags = merge(local.tags, { Name = "${var.env}-web-subnet" })
  app_subnet_tags = merge(local.tags, { Name = "${var.env}-app-subnet" })
  db_subnet_tags  = merge(local.tags, { Name = "${var.env}-db-subnet" })
  web_rt_tags     = merge(local.tags, { Name = "${var.env}-web-rt" })
  app_rt_tags     = merge(local.tags, { Name = "${var.env}-app-rt" })
  db_rt_tags      = merge(local.tags, { Name = "${var.env}-db-rt" })
  igw_tags        = merge(local.tags, { Name = "${var.env}-igw" })
  ngw_tags        = merge(local.tags, { Name = "${var.env}-ngw" })

}
