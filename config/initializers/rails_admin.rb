unless Rails.env == 'test'
require Rails.root.join('lib', 'rails_admin_send_broadcast_email.rb')
require Rails.root.join('lib', 'rails_admin_add_to_mailchimp_list.rb')
RailsAdmin.config do |config|
module RailsAdmin
  module Config
    module Actions
      class SendBroadcastEmail < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      end
      class AddToMailchimpList < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      end

    end
  end
end

  config.current_user_method { current_person } #auto-generated
  config.authorize_with :cancan
  config.attr_accessible_role {:admin}
  config.authenticate_with {
    unless current_person
      session[:return_to] = request.url
      redirect_to '/login', :notice => "You must first log in or sign up before accessing this page."
    end
  }

  config.actions do
    dashboard
    index
    new
    send_broadcast_email
    add_to_mailchimp_list
    show
    edit
    delete
    export
  end

  config.included_models = [Account,AccountDeactivated,Preference,Exchange,ForumPost,FeedPost,BroadcastEmail,Person,PersonActivated,PersonDeactivated,Category,Neighborhood,Req,Offer,BusinessType,ActivityStatus,PlanType]

  config.model Account do
    list do
      field :person do
        label "Name"
      end
      field :offset do
        label "Starting Balance"
      end
      field :balance do
        formatted_value do
          (bindings[:object].balance_with_initial_offset).to_s
        end
      end
      field :credit_limit
      field :updated_at do
        label "Last Transaction"
      end
    end

    edit do
      field :name
      field :person do
        label "Name"
      end
      field :offset do
        label "Starting Balance"
      end
      field :balance do
        formatted_value do
          (bindings[:object].balance_with_initial_offset).to_s
        end
      end
      field :credit_limit
    end

    export do
      field :person
      field :offset do
        label "Starting Balance"
      end
      field :balance do
        formatted_value do
          (bindings[:object].balance_with_initial_offset).to_s
        end
      end
      field :credit_limit
      field :updated_at do
        label "Last Transaction"
      end
    end
  end

  config.model AccountDeactivated do
    label do
      'Deactivated account'
    end
    list do
      field :person do
        label "Name"
      end
      field :offset do
        label "Starting Balance"
      end
      field :balance do
        formatted_value do
          (bindings[:object].balance_with_initial_offset).to_s
        end
      end
      field :credit_limit
      field :updated_at do
        label "Last Transaction"
      end
    end

    edit do
      field :name
      field :person do
        label "Name"
      end
      field :offset do
        label "Starting Balance"
      end
      field :balance do
        formatted_value do
          (bindings[:object].balance_with_initial_offset).to_s
        end
      end
      field :credit_limit
    end

    export do
      field :person
      field :offset do
        label "Starting Balance"
      end
      field :balance do
        formatted_value do
          (bindings[:object].balance_with_initial_offset).to_s
        end
      end
      field :credit_limit
      field :updated_at do
        label "Last Transaction"
      end
    end
  end

  config.model Req do
    label "Request" 
    label_plural "Requests"
    list do
      field :name
      field :person do
        label "Requested by"
      end
      field :created_at
    end

    edit do
      field :group
      field :person do
        label "Requested by"
      end
      field :name
      field :estimated_hours
      field :due_date, :date
      field :description
      field :categories
      field :neighborhoods
    end
  end

  config.model Offer do
    list do
      field :name
      field :person do
        label "Offered by"
      end
      field :created_at
    end

    edit do
      field :group
      field :person do
        label "Offered by"
      end
      field :name
      field :total_available
      field :price
      field :expiration_date, :date
      field :description
      field :categories
      field :neighborhoods
    end
  end

  config.model Preference do
    list do
      field :app_name
    end

    edit do
      field :app_name
      field :server_name
      field :groups
      field :default_group_id do
        properties[:collection] = Group.all.map {|g| [g.name,g.id]}
        partial "select"
      end
      field :locale do
        properties[:collection] = [['English','en'],['Spanish','es'],['French','fr'],['Greek','gr']]
        partial "select"
      end
      field :logout_url
      field :blog_feed_url
      field :new_member_notification
      field :googlemap_api_key
      field :gmail
      field :email_notifications
      field :email_verifications
      field :protected_categories
      field :whitelist
      field :mailchimp_list_id do
        label "Mailchimp List ID"
      end
      field :mailchimp_send_welcome
      field :registration_intro
      field :agreement
      field :about
      field :practice
      field :steps
      field :questions
      field :contact
      field :analytics
    end
  end

  config.model Exchange do
    list do
      field :created_at
      field :customer
      field :worker
      field :amount
      field :metadata do
        label "Memo"
        formatted_value do
          value.name
        end
      end
    end

    edit do
      field :group
      field :customer
      field :worker
      field :amount
      field :notes, :text
      #field :metadata
    end
  end

  config.model FeedPost do
    list do
      field :title
      field :date_published
      field :created_at
      field :updated_at
    end

    edit do
      field :title
      field :content, :text do
        #ckeditor true
      end
    end
  end

  config.model ForumPost do
    list do
      field :person
      field :body
      field :created_at
    end

    edit do
      field :body
    end
  end

  config.model BroadcastEmail do
    edit do
      field :subject
      field :message, :text do
        #ckeditor true
      end
    end
  end

  config.model Category do
    list do
      field :name
    end

    edit do
      field :name
      field :parent_id do
        properties[:collection] = [['',nil]] + Category.by_long_name.map {|c| [c.long_name, c.id]}
        partial "select"
      end
      field :description
    end
  end

  config.model Neighborhood do
    list do
      field :name
    end

    edit do
      field :name
      field :parent_id do
        properties[:collection] = [['',nil]] + Neighborhood.by_long_name.map {|n| [n.long_name, n.id]}
        partial "select"
      end
      field :description
    end
  end

  config.model BusinessType do
    list do
      field :name
      sort_by :name
    end

    edit do
      field :name
      field :description
    end
  end

  config.model ActivityStatus do
    list do
      field :name
      sort_by :name
    end

    edit do
      field :name
      field :description
    end
  end

  config.model PlanType do
    list do
      field :name
      sort_by :name
    end

    edit do
      field :name
      field :description
    end
  end

  config.model Person do
    object_label_method do
      :display_name
    end
    list do
      field :last_logged_in_at do
        label "Last login"
      end
      field :name
      field :business_name
      field :email
      field :deactivated do
        label "Disabled"
      end
      field :email_verified
      field :phone
      field :admin
      field :org
      field :mailchimp_subscribed
      field :openid_identifier
      sort_by :last_logged_in_at
    end

    export do
      field :last_logged_in_at do
        label "Last login"
      end
      field :name
      field :email
      field :deactivated do
        label "Disabled"
      end
      field :email_verified
      field :phone
      field :admin
      field :org
      field :web_site_url
      field :org
      field :title
      field :business_name
      field :legal_business_name
      field :business_type
      field :activity_status
      field :plan_type
      field :support_contact
    end

    edit do
      field :name
      field :email
      field :password
      field :password_confirmation
      field :deactivated
      field :email_verified
      field :phone
      field :admin
      field :web_site_url
      field :org
      field :title
      field :business_name
      field :legal_business_name
      field :business_type
      field :activity_status
      field :plan_type
      field :support_contact
      field :description, :text do
        #ckeditor true
      end
      # generally not appropriate for admin to edit openid since it is an assertion
    end
  end

  config.model PersonActivated do
    object_label_method do
      :display_name
    end
    label do
      'Activated people'
    end
    list do
      field :last_logged_in_at do
        label "Last login"
      end
      field :name
      field :business_name
      field :email
      field :deactivated do
        label "Disabled"
      end
      field :email_verified
      field :phone
      field :admin
      field :org
      field :mailchimp_subscribed
      field :openid_identifier
      sort_by :last_logged_in_at
    end

    export do
      field :last_logged_in_at do
        label "Last login"
      end
      field :name
      field :email
      field :deactivated do
        label "Disabled"
      end
      field :email_verified
      field :phone
      field :admin
      field :org
      field :web_site_url
      field :org
      field :title
      field :business_name
      field :legal_business_name
      field :business_type 
      field :activity_status
      field :plan_type
      field :support_contact
    end

    edit do
      field :name
      field :email
      field :password
      field :password_confirmation
      field :deactivated
      field :email_verified
      field :phone
      field :admin
      field :web_site_url
      field :org
      field :title
      field :business_name
      field :legal_business_name
      field :business_type
      field :activity_status
      field :plan_type
      field :support_contact
      field :description, :text do
        #ckeditor true
      end
      # generally not appropriate for admin to edit openid since it is an assertion
    end
  end

  config.model PersonDeactivated do
    object_label_method do
      :display_name
    end
    label do
      'Deactivated people'
    end
    list do
      field :last_logged_in_at do
        label "Last login"
      end
      field :name
      field :business_name
      field :email
      field :deactivated do
        label "Disabled"
      end
      field :email_verified
      field :phone
      field :admin
      field :org
      field :openid_identifier
      sort_by :last_logged_in_at
    end

    edit do
      field :name
      field :email
      field :password
      field :password_confirmation
      field :deactivated
      field :email_verified
      field :phone
      field :admin
      field :web_site_url
      field :org
      field :title
      field :business_name
      field :legal_business_name
      field :business_type
      field :activity_status
      field :plan_type
      field :support_contact
      field :description, :text do
        #ckeditor true
      end
      # generally not appropriate for admin to edit openid since it is an assertion
    end
  end
end

end
