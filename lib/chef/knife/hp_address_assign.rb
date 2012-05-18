#
# Author:: Matt Ray (<matt@opscode.com>)
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

require 'chef/knife/hp_base'

class Chef
  class Knife
    class HpAddressAssign < Knife

      include Knife::HpBase


      banner "knife hp address assign (options)"

      option :address_id,
             :short       => "-a ADDRESS_ID",
             :long        => "--address ADDRESS_ID",
             :description => "The id for the allocated address"

      option :server_id,
             :short       => "-s SERVER_ID",
             :long        => "--server SERVER_ID",
             :description => "The server to assign the address to"

      def run
        Chef::Log.debug("looking for address: #{config[:address_id]}")
        Chef::Log.debug("looking for server: #{config[:server_id]}")
        validate!
        address.server = server
      end

      def server
        @server ||= connection.servers.get(config[:server_id].to_s)
      end

      def address
        @address ||= connection.addresses.get(config[:address_id].to_s)
      end

      def validate!

        if server.nil?
          ui.error("You have not provided a valid server ID.")
          exit 1
        end
        if address.nil?
          ui.error("You have not provided a valid address ID.")
          exit 1
        end
      end

    end
  end
end
