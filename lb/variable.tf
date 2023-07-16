variable "name" {
  type = string
}
variable "internal" {
  type = bool
}
variable "sg" {
  type = string
}
variable "subnet" {
  type = list(string)
}
variable "vpc" {
  type = string
}
variable "instance" {
  type = list(string)
}
variable "tg_name" {
  type = string
}