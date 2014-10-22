#
# Cookbook Name:: Drupal-Frontend:: Livereload
# Recipe:: default
#
# Copyright 2010, Timothy Whitney
#
# Licensed under the Apache License, Version 2.0 (the 'License");
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

unless node[:drupal_frontend].nil?
  unless node[:drupal_frontend][:css_preprocessor].nil?
    node[:drupal_frontend][:css_preprocessor].each do |site_name, site|
      if site[:active] && site[:livereload]
        # Process each site and create the guard file
        %w(guard guard-livereload).each do |g|
          gem_package g do
            not_if 'gem list | grep #{g}'
            action :install
          end
        end

        location = site_name
        bash 'Initialize Guard and Initialize Guard livereload for #{location}' do
          cmd = 'guard init; guard livereload';
          code <<-EOH
            #{cmd}
          EOH
        end
      end
    end
  end
end

gem_package "chef"
