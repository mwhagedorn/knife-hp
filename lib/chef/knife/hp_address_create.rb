#
# Author:: Mike Hagedorn (<mike.hagedorn@hp.com>)
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
    class HpAddressCreate < Knife

      include Knife::HpBase

      banner "knife hp address create (options)"

      def run

        validate!

        address = connection.addresses.create
        ip      = address.ip


        msg_pair("Public IP Address", ip)

        address_list = [
            ui.color('ID', :bold),
            ui.color('IP', :bold),
            ui.color('Fixed IP', :bold),
            ui.color('Instance ID', :bold)
        ]

        connection.addresses do |adr|
          address_list << adr.id
          address_list << adr.ip
          address_list << adr.fixed_ip
          address_list << adr.instance_id
        end


        address_list = address_list.map do |item|
          item.to_s
        end

        puts ui.list(address_list, :uneven_columns_across, 4)

      end
    end
  end
end
