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

class DateTimeInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    name = attribute_name
    extra_html_options = {}
    if input_type == :date
      extra_html_options[:class] = input_html_classes + ['datepicker']
    end

    if input_type == :time
      extra_html_options[:class] = input_html_classes + ['timepicker']
    end

    @builder.text_field(name, input_html_options.merge(extra_html_options))
  end
end