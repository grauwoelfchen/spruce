module Version
  class Ring < PaperTrail::Version
    include Restorable

    self.table_name    = :rings
    self.sequence_name = :ring_id_seq
  end
end
