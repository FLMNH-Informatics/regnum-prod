class RemoteLinkRenderer < WillPaginate::ActionView::LinkRenderer
  #attr_accessor :callback
  
  protected

  def previous_or_next_page(page, text, classname)
    if page
      link(text, page, :class => classname + ' paginate_link')
    else
      tag(:span, text, :class => classname + ' disabled')
    end
  end

  private

  def link(text, target, attributes = {})
    attributes["data-remote"] = true
    attributes["class"] = "paginate_link"
    super
  end
end