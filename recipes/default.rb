#
# Cookbook Name:: drupal-frontend
# Recipe:: default
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

# Install/configure tools for frontend
# For each site, run the following commands
unless node[:drupal_frontend].nil?
  if node[:drupal_frontend][:grunt]
    # Install grunt and grunt-cli
    cmd = 'npm install -g grunt && npm install -g grunt-cli'
    bash 'Install Grunt and grunt-cli' do
      user 'root'
      code <<-EOH
        #{cmd}
      EOH
    end
  end
  unless node[:drupal_frontend][:css_preprocessor].nil?
    # Install Ruby Gems
    Chef::Log.debug('drupal-frontend::default: Install Rubygems')
    apt_package 'rubygems' do
      action :install # see actions section below
    end

    node[:drupal_frontend][:css_preprocessor].each do |site_name, site|
      if site[:active]
        #Use a CSS Preprocessor
        csspre = site
        location = site_name
        Chef::Log.debug('drupal-frontend::default: node[:drupal-frontend][:css_preprocessor]' + csspre.inspect)

        # Install each gem
        Chef::Log.debug('drupal-frontend::default: node[:drupal-frontend][:css_preprocessor][:gems]' + csspre[:gems].inspect)
        csspre[:gems].each do |g|
          gem_package g do
            not_if 'gem list | grep #{g}'
            action :install
          end
        end
        cmd = ""
        # This allows for the commands to be ran in a single string
        lastCommand = csspre[:commands].last
        Chef::Log.debug('Last '+ lastCommand)
        csspre[:commands].each do |c|
          if c == lastCommand
            cmd << c
          else
            cmd << c + '; '
          end
        end
        bash 'compile CSS' do
          user 'root'
          cwd location
          code <<-EOH
            #{cmd}
          EOH
        end
      end
    end
  end
end
