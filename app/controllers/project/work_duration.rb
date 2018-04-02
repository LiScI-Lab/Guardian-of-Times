class Project::WorkDuration

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
    WorkDuration.new(@date,@start_time,other.end_time,duration)
  end

  def pauses
    @end_time - @start_time - @work_duration
  end
end
