# -*- encoding : utf-8 -*-
module WorkloadFiltersHelper
  def get_option_tags_for_userselection(usersToShow, selectedUsers)

    result = '';
    
    usersToShow.sort_by!{ |u| u.name }

    usersToShow.each do |user|
      selected = selectedUsers.include?(user) ? 'selected="selected"' : ''

      result += "<option value=\"#{h(user.id)}\" #{selected}>#{h(user.name)}</option>"
    end

    return result.html_safe
  end
end
