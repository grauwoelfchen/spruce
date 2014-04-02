module Restorable
  extend ActiveSupport::Concern

  def restore!
    if reify
      reify.save!
    else
      item && item.destroy
    end
  end
end
