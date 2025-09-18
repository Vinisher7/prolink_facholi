class ErpOperationItem < ApplicationRecord
  validates :cod_rot, :seq_rot, :tmp_fix, :tmp_prp, :cod_cre, presence: true

  validates :cod_rot, length: { maximum: 14 }
  validates :cod_cre, length: { maximum: 8 }
end
