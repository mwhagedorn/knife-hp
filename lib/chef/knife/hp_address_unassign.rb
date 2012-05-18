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
    class HpAddressUnassign < Knife

      include Knife::HpBase


      banner "knife hp address unassign (options)"

      option :address_id,
             :short       => "-a ADDRESS_ID",
             :long        => "--address ADDRESS_ID",
             :description => "The id for the address to unassignr"


      def run
        Chef::Log.debug("looking for address: #{config[:address_id]}")
        validate!
        address.server = nil
        print "\n#{ui.color("Address unassigned", :magenta)}"
      end



      def address
        @address ||= connection.addresses.get(config[:address_id].to_s)
      end

      def validate!

        if address.nil?
          ui.error("You have not provided a valid address ID.")
          exit 1
        end
      end

    end
  end
end