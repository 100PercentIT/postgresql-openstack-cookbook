#
# Cookbook Name:: mysql-openstack
# Recipe:: server
#
# Copyright 2012, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# replication parts inspired by https://gist.github.com/1105416

Chef::Log.info("PostgreSQL recipe included")

include_recipe "osops-utils"
include_recipe "monitoring"
include_recipe "postgresql::ruby"
require 'pg'


include_recipe "postgresql::server"

postgresql_info = get_bind_endpoint("postgresql", "db")
postgresql_network = node["postgresql"]["services"]["db"]["network"]
postgresql_acl = node["osops_networks"]["#{postgresql_network}"]

node.set['postgresql']['config']['listen_addresses'] = "localhost, #{postgresql_info['host']}"

node.set['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => postgresql_acl, :method => 'md5'}
]
