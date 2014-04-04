class ChangeRecorder
  def initialize(object)
    @object = object
  end

  def update_attributes(attributes)
    ActiveRecord::Base.transaction do
      record_version(@object) && @object.update_attributes(attributes)
    end
  end

  private

  def record_version(object)
    return false unless object.respond_to?(:store_changes)
    original_only_option = object.paper_trail_options[:only]
    object.paper_trail_options[:only] = %w[name]
    result = object.store_changes
    object.paper_trail_options[:only] = original_only_option
    result
  end
end
