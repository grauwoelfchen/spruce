module Version
  class Cycle < PaperTrail::Version
    include Visible
    include Restorable

    self.table_name    = :cycles
    self.sequence_name = :cycle_id_seq

    belongs_to :user
  end
end
