module ApplicationHelper
  def title(string)
    content_for(:title) { string }
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, :q => params[:q]}, {:class => css_class}
  end

  def state_label(state)
    css = case state.downcase
          when 'accepted'; then 'info'
          when 'processing'; then 'warning'
          when 'onhold'; then 'inverse'
          when 'success'; then 'success'
          when 'failed'; then 'important'
          else 'default'
          end
    content_tag(:span, class: "label label-#{css}") { state.capitalize }
  end
end
