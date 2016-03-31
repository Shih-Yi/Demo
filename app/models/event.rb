class Event < ActiveRecord::Base

  belongs_to :user

  has_one :location 
  validates_presence_of :name
  has_many :attendees
  belongs_to :category
  accepts_nested_attributes_for :location, :allow_destroy => true, :reject_if => :all_blank
  has_many :event_groupships
  has_many :groups, :through => :event_groupships

  has_many :users, through: :memberships
  has_many :memberships

  has_many :likes
  has_many :like_users, :through => :likes, :source => :user

  def find_like_by(user)
    self.likes.find_by_user_id( user.id )
  end

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
end
