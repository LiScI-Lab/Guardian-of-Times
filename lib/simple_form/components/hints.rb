# frozen_string_literal: true
module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Hints
      def hint(wrapper_options = nil)
        @hint ||= begin
          hint = options[:hint]

          if hint.is_a?(String)
            value = html_escape(hint)
          else
            content = translate_from_namespace(:hints)
            value = content.html_safe if content
          end
          if value
            input_html_options[:data] = {} unless input_html_options[:data]
            input_html_options[:data][:tooltip] = value
            input_html_options[:data][:position] = 'bottom'
            input_html_options[:class] << 'tooltipped'
          end
          ""
        end
      end

      def has_hint?
        options[:hint] != false && hint.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Hints)