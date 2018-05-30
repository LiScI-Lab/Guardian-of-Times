class Team::WorkDuration

  attr_reader :date
  attr_reader :start_time
  attr_reader :end_time
  attr_reader :work_duration

  def initialize(date,start,end_time,work_duration=nil)
    @date = date
    @start_time = start
    @end_time = end_time
    if work_duration
      @work_duration = work_duration
    else
      @work_duration = @end_time - @start_time
    end
  end


  def combine(other)
    duration = work_duration + other.work_duration
    ::Team::WorkDuration.new(@date, @start_time, other.end_time, duration)
  end

  def pauses
    @end_time - @start_time - @work_duration
  end
  def pauses_formatted
    Time.at(self.pauses).utc.strftime("%H:%M")
  end
  def work_duration_formatted
    Time.at(@work_duration).utc.strftime("%H:%M")
  end

  def scale_duration_by(factor)
    duration = @work_duration*factor
    ::Team::WorkDuration.new(@date,@start_time, @start_time+duration, duration)
  end
end
