class CreateErpUnityMeasurements < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_unity_measurements do |t|
      t.string :uni_med
      t.string :des_med

      t.timestamps
    end
  end
end
