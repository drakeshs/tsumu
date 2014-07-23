#
# Cookbook Name:: apt
# Attributes:: default
#
# Copyright 2009-2013, Opscode, Inc.
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

default['application']['database']['host'] = "localhost"
default['application']['database']['port'] = "3306"
default['application']['database']['username'] = "root"
default['application']['database']['password'] = ""
default['application']['database']['database'] = "sandbox"


default['application']['cache']['host'] = "localhost"
default['application']['cache']['port'] = "10000"
