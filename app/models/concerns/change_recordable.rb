module ChangeRecordable
  extend ActiveSupport::Concern

  def store_changes
    object_attrs = object_attrs_for_paper_trail(item_before_change)
    return true if object_attrs.empty?
    version_attributes = {
      :event     => "update",
      :user_id   => user_id,
      :whodunnit => user_id.to_s,
      :object    => PaperTrail.serializer.dump(object_attrs)
    }
    v = recorded_changes.new(version_attributes)
    result = v.save
    v.send(:enforce_version_limit!) if result
    result
  end
end
