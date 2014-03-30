PaperTrail.config.version_limit = 3
PaperTrail::Version.module_eval do
  # It dosen't use default PaperTrail::Version
  self.abstract_class = true
end
