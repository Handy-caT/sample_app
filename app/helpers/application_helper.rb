module ApplicationHelper
  include Pagy::Frontend

  def full_title(page_title = '')
    base_title = "Sample App"
    if page_title.empty?
      base_title
    else
      page_title +" | " + base_title
    end
  end

  def nav_tab(title,url,options = {})
    current_page = options.delete :current_page

    css_class = current_page == title ? "active" : ""
    if options[:class]
      options[:class] = options[:class] + " " + css_class
    else
      options[:class] = css_class
    end

    link_to title,url,options
  end

  def currently_at(current_page = '')
    render partial: 'shared/menu_bar',locals: {current_page: current_page}
  end

end
