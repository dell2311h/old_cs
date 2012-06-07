module Modules::Followings

  def self.included(base)

    base.scope :with_flag_followed_by, lambda { |user|
      model_name = base.scoped.klass.to_s
      table_name = base.scoped.table.name
      base.select("#{table_name}.*").select("(#{Relationship.select('COUNT(follower_id)').where("relationships.followable_type = '#{model_name}' AND relationships.followable_id = #{table_name}.id AND relationships.follower_id = ?", user.id).to_sql}) AS followed")
    }

    base.has_many :relationships, :as => :followable, :class_name => "Relationship", :dependent => :destroy
    base.has_many :followers, :through => :relationships, :source => :follower

  end


end

