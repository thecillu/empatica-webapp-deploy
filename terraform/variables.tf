# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-central-1"
}

variable "webapp_bucket" {
  default = "empatica-webapp"
}


variable "github_url" {
  default = "https://github.com/thecillu/empatica-webapp.git"
}

