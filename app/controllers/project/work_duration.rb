class WorkDuration

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

  def date
    @date
  end

  def work_duration
    @work_duration
  end

  def start_time
    @start_time.to_s(:time)
  end
  def end_time
    @start_time.to_s(:time)
  end
end
