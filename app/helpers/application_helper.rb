module ApplicationHelper
  def title(string)
    content_for(:title) { string }
  end
end
