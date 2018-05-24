class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Discard::Model

  def self.use_relative_model_naming?
    true
  end

  def destroy
    if self.class == User::Identity
      super
    else
      raise "Use discard! We don't delete"
    end
  end
  def destroy!
    destroy
  end
end
