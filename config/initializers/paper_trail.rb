PaperTrail::Version.module_eval do
  # don't use default PaperTrail::Version
  self.abstract_class = true
end

