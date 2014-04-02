module Version
  class Cycle < PaperTrail::Version
    include Restorable

    self.table_name    = :cycles
    self.sequence_name = :cycle_id_seq
  end
end
