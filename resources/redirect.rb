#
# Cookbook Name:: robertlemke-webserver
# Resource:: redirect
# Author:: Robert Lemke <rl@robertlemke.com>
#
# Copyright (c) 2013 Robert Lemke
#
# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://opensource.org/licenses/MIT
#

actions :add, :remove

def initialize(*args)
  super
  @action = :add
end

attribute :source_domain, :kind_of => String, :name_attribute => true
attribute :server_aliases, :kind_of => [Array, NilClass], :default => nil
attribute :target_domain, :kind_of => String
