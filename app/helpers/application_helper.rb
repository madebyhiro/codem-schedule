module ApplicationHelper
  def title(page_title)
    content_for(:title) { h(page_title) }
  end
end
