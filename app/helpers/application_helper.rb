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
end
