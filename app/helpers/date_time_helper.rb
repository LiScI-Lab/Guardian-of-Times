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
end
