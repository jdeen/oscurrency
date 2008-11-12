# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  ## Menu helpers
  
  def menu
    home     = menu_element("Home",   home_path)
    people   = menu_element("People", people_path)
    if Forum.count == 1
      forum = menu_element("Forum", forum_path(Forum.find(:first)))
    else
      forum = menu_element("Forums", forums_path)
    end
    resources = menu_element("Resources", "http://docs.insoshi.com/")
    if logged_in? and not admin_view?
      profile  = menu_element("Profile",  person_path(current_person))
      requests = menu_element("Requests", reqs_path)
      categories = menu_element("Categories", categories_path)
      messages = menu_element("Messages", messages_path)
#      blog     = menu_element("Blog",     blog_path(current_person.blog))
      photos   = menu_element("Photos",   photos_path)
#      contacts = menu_element("Contacts",
#                              person_connections_path(current_person))
#      links = [home, profile, contacts, messages, blog, people, forum]
      events   = menu_element("Events", events_path)
      links = [home, profile, requests, people, messages, forum, categories]
      # TODO: remove 'unless production?' once events are ready.
      links.push(events) #unless production?
      
    elsif logged_in? and admin_view?
      home =    menu_element("Home", home_path)
      spam = menu_element("Spam", admin_broadcast_emails_path)
      categories = menu_element("Categories", categories_path)
      people =  menu_element("People", admin_people_path)
      events   = menu_element("Events", events_path)
      forums =  menu_element(inflect("Forum", Forum.count),
                             admin_forums_path)
      preferences = menu_element("Prefs", admin_preferences_path)
      links = [home, spam, categories, people, forums, preferences]
    else
      links = [home, people]
    end
    if global_prefs.about.blank?
      links
    else
      links.push(menu_element("About", about_url))
    end
  end
  
  def menu_element(content, address)
    { :content => content, :href => address }
  end
  
  def menu_link_to(link, options = {})
    link_to(link[:content], link[:href], options)
  end
  
  def menu_li(link, options = {})
    klass = "n-#{link[:content].downcase}"
    klass += " active" if current_page?(link[:href])
    content_tag(:li, menu_link_to(link, options), :class => klass)
  end
  
  # Return true if the user is viewing the site in admin view.
  def admin_view?
    params[:controller] =~ /admin/ and admin?
  end
  
  def admin?
    logged_in? and current_person.admin?
  end
  
  # Set the input focus for a specific id
  # Usage: <%= set_focus_to 'form_field_label' %>
  def set_focus_to(id)
    javascript_tag("$('#{id}').focus()");
  end
 
  # Same as Rails' simple_format helper without using paragraphs
  def simple_format_without_paragraph(text)
    text.to_s.
      gsub(/\r\n?/, "\n").                    # \r\n and \r -> \n
      gsub(/\n\n+/, "<br /><br />").          # 2+ newline  -> 2 br
      gsub(/([^\n]\n)(?=[^\n])/, '\1<br />')  # 1 newline   -> br
  end

  # Display text by sanitizing and formatting.
  # The html_options, if present, allow the syntax
  #  display("foo", :class => "bar")
  #  => '<p class="bar">foo</p>'
  def display(text, html_options = nil)
    begin
      if html_options
        html_options = html_options.stringify_keys
        tag_opts = tag_options(html_options)
      else
        tag_opts = nil
      end
      processed_text = format(sanitize(text))
    rescue
      # Sometimes Markdown throws exceptions, so rescue gracefully.
      processed_text = content_tag(:p, sanitize(text))
    end
    add_tag_options(processed_text, tag_opts)
  end
  
  # Output a column div.
  # The current two-column layout has primary & secondary columns.
  # The options hash is handled so that the caller can pass options to 
  # content_tag.
  # The LEFT, RIGHT, and FULL constants are defined in 
  # config/initializers/global_constants.rb
  def column_div(options = {}, &block)
    klass = options.delete(:type) == :primary ? "col1" : "col2"
    # Allow callers to pass in additional classes.
    options[:class] = "#{klass} #{options[:class]}".strip
    content = content_tag(:div, capture(&block), options)
    concat(content, block.binding)
  end

  def account_link(person, options = {})
    path = person_path(person) # XXX link to transactions
    img = image_tag("icons/bargraph.gif")
    action = "Balance: #{person.account.balance} hours"
    opts = {}
    str = link_to(img,path, opts)
    str << "&nbsp;"
    str << link_to_unless_current(action, path, opts)
  end

  def email_link(person, options = {})
    reply = options[:replying_to]
    if reply
      path = reply_message_path(reply)
    else
      path = new_person_message_path(person)
    end
    img = image_tag("icons/email.gif")
    action = reply.nil? ? "Send a message" : "Send reply"
    opts = { :class => 'email-link' }
    str = link_to(img, path, opts)
    str << "&nbsp;"
    str << link_to_unless_current(action, path, opts)
  end

  # Return a formatting note (depends on the presence of a Markdown library)
  def formatting_note
    if markdown?
      %(HTML and
        #{link_to("Markdown",
                  "http://daringfireball.net/projects/markdown/basics",
                  :popup => true)}
       formatting supported)
    else 
      "HTML formatting supported"
    end
  end



# YUI
def yui_headers  
    @yui_head = capture do
         content_for (:head) {'           
        <!-- Combo-handled YUI CSS files: -->
        <link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.6.0/build/assets/skins/sam/skin.css">
        <!-- Combo-handled YUI JS files: -->
        <script type="text/javascript" src="http://yui.yahooapis.com/combo?2.6.0/build/yahoo-dom-event/yahoo-dom-event.js&2.6.0/build/container/container_core-min.js&2.6.0/build/menu/menu-min.js&2.6.0/build/element/element-beta-min.js&2.6.0/build/button/button-min.js&2.6.0/build/editor/editor-min.js"></script>
'}
  end

end

def yui_headers_debug  
    @yui_head = capture do
         content_for (:head) {'           
           <!-- Combo-handled YUI CSS files: -->
           <link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.6.0/build/menu/assets/skins/sam/menu.css&2.6.0/build/button/assets/skins/sam/button.css&2.6.0/build/editor/assets/skins/sam/editor.css&2.6.0/build/logger/assets/skins/sam/logger.css">
           <!-- Combo-handled YUI JS files: -->
           <script type="text/javascript" src="http://yui.yahooapis.com/combo?2.6.0/build/yahoo/yahoo-debug.js&2.6.0/build/dom/dom-debug.js&2.6.0/build/event/event-debug.js&2.6.0/build/container/container_core-debug.js&2.6.0/build/menu/menu-debug.js&2.6.0/build/element/element-beta-debug.js&2.6.0/build/button/button-debug.js&2.6.0/build/editor/editor-debug.js&2.6.0/build/logger/logger-debug.js"></script>
'}
  end

end

def yui_headers_raw
    @yui_head = capture do
         content_for (:head) {'           
           <!-- Combo-handled YUI CSS files: -->
           <link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.6.0/build/menu/assets/skins/sam/menu.css&2.6.0/build/button/assets/skins/sam/button.css&2.6.0/build/editor/assets/skins/sam/editor.css">
           <!-- Combo-handled YUI JS files: -->
           <script type="text/javascript" src="http://yui.yahooapis.com/combo?2.6.0/build/yahoo/yahoo.js&2.6.0/build/dom/dom.js&2.6.0/build/event/event.js&2.6.0/build/container/container_core.js&2.6.0/build/menu/menu.js&2.6.0/build/element/element-beta.js&2.6.0/build/button/button.js&2.6.0/build/editor/editor.js"></script>
'}
  end

end

  private
  
    def inflect(word, number)
      number > 1 ? word.pluralize : word
    end
    
    def add_tag_options(text, options)
      text.gsub("<p>", "<p#{options}>")
    end
    
    # Format text using BlueCloth (or RDiscount) if available.
    def format(text)
      if text.nil?
        ""
      elsif defined?(RDiscount)
        RDiscount.new(text).to_html
      elsif defined?(BlueCloth)
        BlueCloth.new(text).to_html
      elsif no_paragraph_tag?(text)
        content_tag :p, text
      else
        text
      end
    end
    
    # Is a Markdown library present?
    def markdown?
      defined?(RDiscount) or defined?(BlueCloth)
    end
    
    # Return true if the text *doesn't* start with a paragraph tag.
    def no_paragraph_tag?(text)
      text !~ /^\<p/
    end
end
