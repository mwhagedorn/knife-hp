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
    class HpImageList < Knife

      include Knife::HpBase

      banner "knife hp image list (options)"

      option :type,
             :short       => "-t IMAGE_TYPE",
             :long        => "--type IMAGE_TYPE",
             :description => "list the images, optionally filtering by type (machine|kernel|ramdisk)"

      def run

        validate!

        image_list = [
            ui.color('ID', :bold),
            ui.color('Name', :bold),
        ]

        if config[:type] == "machine"
          @images = machine_images
        elsif config[:type] == "kernel"
          @images = kernel_images
        elsif config[:type] == "ramdisk"
          @images = ramdisk_images
        else
          @images = connection.images
        end

        @images.sort_by do |image|
          [image.name.downcase, image.id].compact
        end.each do |image|
          image_list << image.id
          image_list << image.name
        end

        image_list = image_list.map do |item|
          item.to_s
        end

        puts ui.list(image_list, :uneven_columns_across, 2)
      end
    end

    def machine_images
      connection.images.select { |i| machine_image?(i) }
    end

    def kernel_images
      connection.images.select { |i| kernel_image?(i) }
    end

    def ramdisk_images
         connection.images.select { |i| ramdisk_image?(i) }
       end

    def machine_image?(image)
      # TODO rework this when openstack api provides kernal vs machine image metadata
      !image.name.match(/Kernel/) && !image.name.match(/Ramdisk/)
    end

    def kernel_image?(image)
       image.name.match(/Kernel/)
    end

    def ramdisk_image?(image)
       image.name.match(/Ramdisk/)
    end
  end
end
