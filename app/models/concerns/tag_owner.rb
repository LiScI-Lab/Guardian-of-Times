module TagOwner
  extend ActiveSupport::Concern

  included do

    def own_tag_list(owner=nil)
      owner_tag_list_on(owner, :tags) if owner
    end

    def own_tag_list=(own_tag_list)
      set_owner_tag_list_on(own_tag_list[:owner], :tags, own_tag_list[:tag_list]) if own_tag_list.is_a? Hash
    end
  end
end