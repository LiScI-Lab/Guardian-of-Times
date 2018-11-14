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

module ApplicationHelper
  def asciidoc(text)
    Asciidoctor.convert(text, safe: :server, attributes: ["source-highlighter=rouge"]).html_safe
  end

  def distance_of_time_or_null seconds, expect = :seconds
    if seconds != 0
      distance_of_time seconds, accumulate_on: :hours, except: expect
    else
      '-'
    end
  end

  def get_role_list_helper
    Team::Member.roles
  end

  def get_role_list_helper
    Team::Member.roles.keys.reduce([]) do |acc, role|
      acc << [t("course.member.roles.#{role}"), role, {disabled: (@current_member.role_less_than? role or role.to_sym == :owner)}]
    end.reverse
  end
end
