module Statistics
  extend ActiveSupport::Concern


  included do
    def current_month_spend_time_by_day_of_week
      in_month_spend_time_by_day_of_week(DateTime.now)
    end

    def in_month_spend_time_by_day_of_week(date)
      time_spend_time_by_day_of_week_data progresses.kept.in_month(date).finished
    end

    def all_time_spend_time_by_day_of_week
      time_spend_time_by_day_of_week_data progresses.kept.finished
    end

    def time_spend_time_by_day_of_week_data(progresses)
      data = {}
      (0..6).each {|i| data[I18n.t('date.day_names')[i]] = 0}


      progresses.group_by_day_of_week(&:start).map do |k, v|
        hours = 0
        v.each do |progress|
          hours += progress.time_spend
        end
        hours = hours / 3600
        data[I18n.t('date.day_names')[k]] = hours.to_i
      end

      data
    end


    def current_month_spend_time_by_hour_of_day
      in_month_spend_time_by_hour_of_day(DateTime.now)
    end

    def in_month_spend_time_by_hour_of_day(date)
      time_spend_time_by_hour_of_day_data progresses.kept.in_month(date).finished
    end

    def all_time_spend_time_by_hour_of_day
      time_spend_time_by_hour_of_day_data progresses.kept.finished
    end

    def time_spend_time_by_hour_of_day_data(progresses)
      data = {}
      (0..23).each {|i| data[i] = 0}


      progresses.group_by_hour_of_day(&:start).map do |k, v|
        hours = 0
        v.each do |progress|
          hours += progress.time_spend
        end
        hours = hours / 3600
        data[k] = hours.to_i
      end

      data
    end
  end
end