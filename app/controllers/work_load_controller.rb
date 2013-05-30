class WorkLoadController < ApplicationController

  unloadable

  helper :gantt
  helper :issues
  helper :projects
  helper :queries

  include QueriesHelper

  def show
    
    @fecha_actual = ( !params[:fecha_actual].nil? && params[:fecha_actual].respond_to?(:to_date)  ) ? params[:fecha_actual].gsub('/', '-').to_date.strftime("%Y-%m-%d") : DateTime.now.strftime("%Y-%m-%d")

    if ( params[:month].nil? ||   params[:months].nil? ||  params[:year].nil?   ) then
      params[:month] = DateTime.now.month
      params[:months] = 2
      params[:year] = DateTime.now.year
    end

    params[:show_issues] = ( params[:show_issues].nil? ) ? "1" : params[:show_issues]

    @gantt = Redmine::Helpers::Gantt.new(params)

    retrieve_query
    @gantt.query = @query if @query.valid? 

    @usersToDisplay   = (!params[:usuarios_id].nil?) ?  User.find_all_by_id(params[:usuarios_id].split(',')) : []
    @utils      = ListingUser.new(IssueStatus.find_all_by_is_closed(false, :select => 'id').map(&:id))
    @totalDays = @utils.tools.distance_of_time_in_days(@gantt.date_from, @gantt.date_to)

    @daysUntilMonday = (( 7 - @gantt.date_from.cwday ) + 1)
    @monday          = @gantt.date_from.to_date

    @daysUntilMonday.times do
		  @monday = @monday.next
	  end

    @numberOfWeeks = (@totalDays / 7).round

    current_date = @gantt.date_from
    final_date   = @gantt.date_to
    @barras_days = []
    while ( current_date.to_time < final_date.to_time ) do
      @barras_days.push( 16 * @utils.tools.distance_of_time_in_days( @gantt.date_from.to_date.strftime("%Y-%m-%d"), current_date.to_date.end_of_month.strftime("%Y-%m-%d") ) )
      current_date = current_date.to_date.end_of_month + 1
    end

  end

  def sort_clear

  end

#########
protected
#########

  def is_user_logged_in
    if !User.current.logged?
      render_403
    end
  end
  
end
