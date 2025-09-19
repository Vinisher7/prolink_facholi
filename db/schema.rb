# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_09_19_145513) do
  create_table "bagging_stops", force: :cascade do |t|
    t.datetime "ini_parada"
    t.datetime "fim_parada"
    t.string "cod_parada"
    t.string "desc_parada"
    t.string "ensacadeira"
    t.string "num_orp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bagging_weights", force: :cascade do |t|
    t.datetime "dt_ini"
    t.string "ensacadeira"
    t.float "peso_saco"
    t.string "num_orp"
    t.string "temp_ciclo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "batelada_passos", force: :cascade do |t|
    t.bigint "batelada_id", null: false
    t.integer "seq"
    t.string "cod_eqp"
    t.string "cod_pro"
    t.float "qtd_prev"
    t.float "qtd_real"
    t.float "histerese"
    t.datetime "dat_ini"
    t.datetime "dat_fim"
    t.string "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batelada_id"], name: "index_batelada_passos_on_batelada_id"
  end

  create_table "bateladas", force: :cascade do |t|
    t.integer "num_orp"
    t.integer "dosagem"
    t.string "cod_linha"
    t.datetime "dat_ini"
    t.datetime "data_fim"
    t.boolean "is_retrabalho"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contingencia_model_items", force: :cascade do |t|
    t.integer "seq_mod"
    t.string "cod_cmp"
    t.float "qtd_uti"
    t.integer "cod_balanca"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "origem"
    t.integer "num_orp"
  end

  create_table "contingencia_production_orders", force: :cascade do |t|
    t.integer "num_orp"
    t.string "cod_pro"
    t.float "qtd_prd"
    t.string "qtd_bat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "cod_linha"
  end

  create_table "contingencia_products", force: :cascade do |t|
    t.string "cod_pro"
    t.string "des_pro"
    t.string "uni_med"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cod_pro"], name: "index_contingencia_products_on_cod_pro", unique: true
  end

  create_table "equipment_lines", force: :cascade do |t|
    t.string "cod_linha"
    t.string "cod_eqp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_equipments", force: :cascade do |t|
    t.string "cod_rec"
    t.string "cod_eqp"
    t.string "des_cre"
    t.string "des_eqp"
    t.string "eqp_pai"
    t.string "eqp_pri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pas_max"
  end

  create_table "erp_model_generals", force: :cascade do |t|
    t.string "cod_mod"
    t.integer "ver_mod"
    t.string "des_mod"
    t.string "uni_med"
    t.date "dat_ini"
    t.date "dat_fim"
    t.float "qtd_bas"
    t.char "sit_mod", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_model_items", force: :cascade do |t|
    t.string "cod_mod"
    t.integer "ver_mod"
    t.integer "seq_mod"
    t.string "cod_cmp"
    t.float "qtd_uti"
    t.string "cod_balanca"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_operation_generals", force: :cascade do |t|
    t.string "cod_rot"
    t.integer "ver_rot"
    t.string "des_rot"
    t.float "qtd_base"
    t.float "lot_tec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_operation_items", force: :cascade do |t|
    t.string "cod_rot"
    t.integer "seq_rot"
    t.float "tmp_fix"
    t.float "tmp_prp"
    t.string "cod_cre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ver_rot"
  end

  create_table "erp_production_orders", force: :cascade do |t|
    t.string "cod_ori"
    t.integer "num_orp"
    t.string "des_orp"
    t.string "cod_pro"
    t.string "cod_mod"
    t.string "cod_rot"
    t.integer "ver_mod"
    t.integer "ver_rot"
    t.date "dat_emi"
    t.date "dat_ent"
    t.float "qtd_prd"
    t.integer "num_pri"
    t.string "qtd_bat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_products", force: :cascade do |t|
    t.string "cod_pro"
    t.string "des_pro"
    t.string "cpl_pro"
    t.string "uni_med"
    t.string "cod_mod"
    t.string "cod_rot"
    t.string "cod_bar"
    t.string "des_teo"
    t.string "cod_cte"
    t.integer "seq_ccp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_reason_stops", force: :cascade do |t|
    t.string "cod_gru"
    t.string "cod_mtv"
    t.string "des_mtv"
    t.string "abr_mtv"
    t.boolean "par_lin"
    t.integer "tip_par"
    t.boolean "sit_mtv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_shifts", force: :cascade do |t|
    t.string "cod_turno"
    t.string "des_turno"
    t.string "hora_ini"
    t.string "hora_fim"
    t.string "dia"
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_stop_groups", force: :cascade do |t|
    t.string "cod_gru"
    t.string "des_gru"
    t.string "abr_gru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "erp_unity_measurements", force: :cascade do |t|
    t.string "uni_med"
    t.string "des_med"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_stops", force: :cascade do |t|
    t.string "cod_linha"
    t.string "cod_parada"
    t.string "desc_parada"
    t.datetime "dat_ini"
    t.datetime "dat_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lines", force: :cascade do |t|
    t.string "cod_linha"
    t.string "des_linha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, where: "([reset_password_token] IS NOT NULL)"
  end

  add_foreign_key "batelada_passos", "bateladas"
end
