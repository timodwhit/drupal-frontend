#
# Cookbook Name:: drupal-frontend
# Recipe:: nodejs
#
# Copyright (C) 2014 Tim Whitney tim.d.whitney@gmail.com
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

# Install/configure nodejs for frontend
# For each site, run the following commands

unless node[:drupal_frontend].nil?
  unless node[:drupal_frontend][:css_preprocessor].nil?
    include_recipe "nodejs"
    include_recipe "nodejs::npm"
    node[:drupal_frontend][:css_preprocessor].each do |site_name, site|
      if site[:active]
        site[:nodejs][:packages].each do |package_name, package|
          if package[:global]
            nodejs_npm package_name do
              version package[:version]
            end
          else
            nodejs_npm package_name do
              path site_name
              version package[:version]
            end
          end
        end
      end
    end
  end
end
