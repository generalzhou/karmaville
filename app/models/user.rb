class User < ActiveRecord::Base

  has_many :karma_points

  attr_accessible :first_name, :last_name, :email, :username, :total_karma

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  validates :username,
            :presence => true,
            :length => {:minimum => 2, :maximum => 32},
            :format => {:with => /^\w+$/},
            :uniqueness => {:case_sensitive => false}

  validates :email,
            :presence => true,
            :format => {:with => /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i},
            :uniqueness => {:case_sensitive => false}

  validates :total_karma,
            :presence => true

  def self.by_karma
    User.order('total_karma DESC')
    # joins(:karma_points).group('users.id').order('SUM(karma_points.value) DESC')
  end

  def update_karma
    self.total_karma = self.karma_points.sum(:value)
    self.save(:validate => false)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
