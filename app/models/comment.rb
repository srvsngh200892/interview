class Comment < ActiveRecord::Base
	#author saurav
	#date 15/04/2016

  belongs_to :relation, polymorphic: true

  validates_presence_of :body

end