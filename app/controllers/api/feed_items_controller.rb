class Api::FeedItemsController < Api::BaseController

  before_filter :find_feedable, :get_feed_type, :only => :index

  def index
    @feed_items = FeedItem.search_by(@feedable, params)

    if (@feed_items_count = @feed_items.count) > 0
      @feed_items = @feed_items.paginate(:page => params[:page], :per_page => params[:per_page])
    else
      render :status => :not_found, json: {}
    end

    render :status => :ok, :action => :index
  end

  private

    def find_feedable
      @feedable = case params[:feedable]
        when /performers|places|events|users/
          class_name = params[:feedable][0..-2]
          model_class = class_name.capitalize.constantize
          model_class.find params[:id]
        else
          current_user if me?
      end
    end

    def get_feed_type
      @feed_type = @feedable.instance_of?(User) ? (params[:feed_type] || :user) : @feedable.class.to_s.downcase.to_sym
    end

end

