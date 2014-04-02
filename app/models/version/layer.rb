module Version
  class Layer < PaperTrail::Version
    include Restorable

    self.table_name    = :layers
    self.sequence_name = :layer_id_seq
  end
end
