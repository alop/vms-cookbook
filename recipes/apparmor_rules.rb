#
# Cookbook Name:: vms
# Recipe:: apparmor_rules
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"

::Chef::Resource::AptRepository.send(:include, Gridcentric::Vms::Helpers)

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

apt_repository "gridcentric-vms" do
  uri construct_repo_uri("vms", node)
  components ["gridcentric", "multiverse"]
  key construct_key_uri(node)
  notifies :run, resources(:execute => "apt-get update"), :immediately
  only_if { platform?("ubuntu") }
end

package "vms-apparmor" do
  action :install
  options "-o APT::Install-Recommends=0"
end
