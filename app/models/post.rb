class Post < ActiveRecord::Base
  validates_presence_of :title, :body

  has_many :comments, as: :relation

  def self.get_post(id)
  	Post.find_by_id(id)
  end	


end
