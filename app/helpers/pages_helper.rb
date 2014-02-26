module PagesHelper

  def screenshot(filename, alt=nil, size=nil)
    link_to "/assets/#{filename}", target: "_blank" do
      image_tag filename, size: size || "200x160", alt: alt
    end
  end
end
