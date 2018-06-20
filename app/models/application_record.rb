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

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Discard::Model

  def self.use_relative_model_naming?
    true
  end

  def destroy
    if self.class == User::Identity
      super
    else
      raise "Use discard! We don't delete"
    end
  end
  def destroy!
    destroy
  end
end
