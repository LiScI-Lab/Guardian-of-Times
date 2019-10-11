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

module DateTimeHelper
  def month_with_index
    Date::MONTHNAMES.each_with_index.collect{|m,i| [m,i]}
  end
  def current_month
    month_with_index[DateTime.now.month]
  end

  def seconds_to_hours(v)
    (v / 3600).round
  end

  def format_duration duration
    total_seconds = duration.to_i
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)
    "%02d:%02d" % [hours, minutes]
  end
end
