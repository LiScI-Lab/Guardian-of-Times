############
##
## Copyright 2018 M. Hoppe & N. Justus
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############

module TagOwner
  extend ActiveSupport::Concern

  included do

    def own_tag_list(owner=nil)
      owner_tag_list_on(owner, :tags) if owner
    end

    def own_tag_list=(own_tag_list)
      set_owner_tag_list_on(own_tag_list[:owner], :tags, own_tag_list[:tag_list]) if own_tag_list.is_a? Hash
    end
  end
end