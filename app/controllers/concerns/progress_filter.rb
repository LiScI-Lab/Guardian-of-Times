module ProgressFilter
  include ActiveSupport::Concern
  def get_filtered_progresses(model_with_progresses)
    month_filter = params[:filter][:month].select {|e| not e.blank?}.map {|str| Date.parse(str)} if params[:filter] and params[:filter][:month]
    tag_list = params[:filter][:tag_list] if params[:filter]
    member_filter = params[:filter][:member_id].select {|e| not e.blank?} if params[:filter] and params[:filter][:member_id]

    progresses = if month_filter&.any?
                   model_with_progresses.progresses.in_months(month_filter)
                 else
                   model_with_progresses.progresses
                 end

    progresses = if member_filter&.any?
                   progresses
                     .joins(:member)
                     .joins(:user)
                     .where(member: member_filter)
                 else
                   progresses
                 end

    if tag_list and not tag_list.blank?
      progresses.tagged_with(tag_list, any: true)
    else
      progresses
    end
  end
end
