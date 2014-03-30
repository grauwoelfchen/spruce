module Revertible
  extend ActiveSupport::Concern

  def revert!
    if reify
      reify.save!
    else
      item && item.destroy
    end
  end
end
