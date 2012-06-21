class Api::RelationshipsController < Api::BaseController

  before_filter :set_source_user, :only => :followings
  before_filter :find_followable, :only => [:followers, :create, :destroy]
  before_filter :set_entities_type, :only => [:followings, :followers]

  def followings
    @entities = @source_user.followed_with_type(params[:type]).with_flag_followed_by(current_user).with_relationships_counters
    render status: set_status_by(@entities), action: :index
  end

  def followers
    @entities = @followable.followers.with_flag_followed_by(current_user).with_relationships_counters
    render status: set_status_by(@entities), action: :index
  end


  def create
    current_user.follow(@followable)
    render status: :ok, json: {}
  end

  def destroy
    current_user.unfollow(@followable)
    render status: :ok, json: {}
  end


  private

    def set_source_user
      @source_user = me? ? current_user : User.find(params[:user_id])
    end

    def set_status_by collection
      collection.any? ? :ok : :not_found
    end

    def find_followable
      @followable = case params[:followable]
        when /performers|places|events|users/
          class_name = params[:followable][0..-2]
          model_class = class_name.capitalize.constantize
          model_class.find params[:id]
        else
          current_user
      end
    end

    def set_entities_type
      @entities_type = params[:type] || 'users'
    end

end

