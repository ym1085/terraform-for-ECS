#!/bin/bash
terraform refresh
terraform fmt -check
terraform validate
terraform plan