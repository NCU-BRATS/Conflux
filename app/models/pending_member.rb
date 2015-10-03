class PendingMember < ActiveRecord::Base
  include EventableConcern

  belongs_to :project

  belongs_to :inviter, class_name: 'User'

end
