# == Schema Information
# Schema version: 15
#
# Table name: comments
#
#  id               :integer(11)     not null, primary key
#  commenter_id     :integer(11)     
#  commentable_id   :integer(11)     
#  commentable_type :string(255)     default(""), not null
#  body             :text            
#  created_at       :datetime        
#  updated_at       :datetime        
#

class WallComment < Comment
  belongs_to :person, :counter_cache => true
  belongs_to :commenter, :class_name => "Person",
                         :foreign_key => "commenter_id"
  
  validates_presence_of :commenter
  validates_length_of :body, :maximum => SMALL_TEXT_LENGTH
  
  after_create :log_activity
  
  private
  
    def log_activity
      add_activities(:item => self, :person => person)
    end
end
