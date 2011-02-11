#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Nuo Yan (<nuo@opscode.com>)
# Copyright:: Copyright (c) 2009, 2010, 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/knife'
require 'chef/json'

class Chef
  class Knife
    class CookbookList < Knife

      banner "knife cookbook list (options)"

      option :with_uri,
        :short => "-w",
        :long => "--with-uri",
        :description => "Show corresponding URIs"

      option :all_versions,
        :short => "-a",
        :long => "--show-all-versions",
        :description => "Show all available versions."

      def run
        env          = Chef::Config[:environment]
        num_versions = config[:all_versions] ? "num_versions=all" : "num_versions=1"
        api_endpoint = env ? "/environments/#{env}/cookbooks?#{num_versions}" : "/cookbooks?#{num_versions}"
        Chef::Log.info("Showing latest versions. Use --show-all to list all available versions.") unless config[:all_versions]
        output(format_cookbook_list_for_display(rest.get_rest(api_endpoint)))
      end

      def format_cookbook_list_for_display(item)
        if config[:with_uri]
          item
        else
          item.inject({}){|result, (k,v)|
            result[k] = v["versions"].inject([]){|res, ver| res.push(ver["version"]); res}
            result
          }
        end
      end

    end
  end
end



