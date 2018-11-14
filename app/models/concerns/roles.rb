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

module Roles
  extend ActiveSupport::Concern
  #originally copied from gildamesh:
  #https://git.thm.de/thsg47/gamification/blob/master/app/models/has_roles.rb

  included do
    scope :role_less_than, -> (role) {
      where("\"#{self.table_name}\".role < ?", roles[role.to_sym])
    }
    scope :role_greater_equals, -> (role) {
      where("\"#{self.table_name}\".role >= ?", roles[role.to_sym])
    }
  end

  def role_less_than? role_sym
    self.class.roles[role.to_sym] < self.class.roles[role_sym.to_sym]
  end

  def role_less_equals? role_sym
    self.class.roles[role.to_sym] <= self.class.roles[role_sym.to_sym]
  end

  def role_greater_than? role_sym
    self.class.roles[role.to_sym] > self.class.roles[role_sym.to_sym]
  end

  def role_greater_equals? role_sym
    self.class.roles[role.to_sym] >= self.class.roles[role_sym.to_sym]
  end
end
