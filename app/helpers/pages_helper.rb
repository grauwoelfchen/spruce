module PagesHelper
  # Renders screenshot image with its link.
  #
  # @param [String] filename
  # @param [Array<String, NilClass>] alt
  # @param [Array<String, NilClass>] size
  # @return NilClass
  def screenshot(filename, alt=nil, size=nil)
    link_to image_path(filename), target: "_blank" do
      image_tag filename, size: size || "200x160", alt: alt
    end
  end
end
