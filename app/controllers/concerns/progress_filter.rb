module ProgressFilter
  include ActiveSupport::Concern
  def get_filtered_progresses(model_with_progresses)
    month_filter = params[:filter][:month] if params[:filter]
    tag_list ||= params[:filter][:tag_list] if params[:filter]
    member_filter ||= params[:filter][:member_name] if params[:filter]

    progresses = if month_filter && !month_filter.empty? && month_filter.to_i!=0 then
                   month_date = Date.new(DateTime.now.year, month_filter.to_i)
                   model_with_progresses.progresses.in_month(month_date)
                 else
                   model_with_progresses.progresses
                 end

    progresses = if member_filter then
                   progresses
                     .joins(:member)
                     .joins(:user)
                     .where(users: {realname: member_filter})
                 else
                   progresses
                 end

    if tag_list && !tag_list.empty? then
      progresses.tagged_with(tag_list, any: true)
    else
      progresses
    end
  end
end
