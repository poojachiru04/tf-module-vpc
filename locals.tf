locals {

  tags            = merge(var.tags, { module_name = "tf-module-vpc" })
  vpc_tags        = merge(local.tags, { Name = "${var.env}-vpc" })
  lb_subnet_tags  = merge(local.tags, { Name = "${var.env}-lb-subnet" })
  eks_subnet_tags = merge(local.tags, { Name = "${var.env}-eks-subnet" })
  db_subnet_tags  = merge(local.tags, { Name = "${var.env}-db-subnet" })
  lb_rt_tags      = merge(local.tags, { Name = "${var.env}-lb-rt" })
  eks_rt_tags     = merge(local.tags, { Name = "${var.env}-eks-rt" })
  db_rt_tags      = merge(local.tags, { Name = "${var.env}-db-rt" })
  igw_tags        = merge(local.tags, { Name = "${var.env}-igw" })
  ngw_tags        = merge(local.tags, { Name = "${var.env}-ngw" })

}
