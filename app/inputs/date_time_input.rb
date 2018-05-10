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