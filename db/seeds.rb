# Seeds para popular o banco com dados de teste
# Relacionamento: produtos → modelos → itens → equipamentos → linhas

puts "🧹 Limpando tabelas (exceto lines, erp_equipments, equipment_lines e users)..."

# Limpar tabelas na ordem correta (respeitando foreign keys)
BateladaPasso.delete_all
Batelada.delete_all
BaggingStop.delete_all
BaggingWeight.delete_all
ContingenciaModelItem.delete_all
ContingenciaProductionOrder.delete_all
ContingenciaProduct.delete_all
ErpProductionOrder.delete_all
ErpProduct.delete_all
ErpModelItem.delete_all
ErpModelGeneral.delete_all
ErpOperationItem.delete_all
ErpOperationGeneral.delete_all
LineStop.delete_all

puts "✅ Tabelas limpas!"

puts "📦 Criando unidades de medida..."
ErpUnityMeasurement.find_or_create_by(uni_med: "KG") { |u| u.des_med = "Quilograma" }
ErpUnityMeasurement.find_or_create_by(uni_med: "L") { |u| u.des_med = "Litro" }
ErpUnityMeasurement.find_or_create_by(uni_med: "UN") { |u| u.des_med = "Unidade" }
ErpUnityMeasurement.find_or_create_by(uni_med: "M") { |u| u.des_med = "Metro" }
ErpUnityMeasurement.find_or_create_by(uni_med: "TON") { |u| u.des_med = "Tonelada" }

puts "🏭 Criando modelos gerais..."
modelos = [
  { cod_mod: "MOD001", ver_mod: 1, des_mod: "Modelo Ração Suína", uni_med: "KG", dat_ini: Date.current, dat_fim: Date.current + 1.year, qtd_bas: 1000.0, sit_mod: "A" },
  { cod_mod: "MOD002", ver_mod: 1, des_mod: "Modelo Ração Bovina", uni_med: "KG", dat_ini: Date.current, dat_fim: Date.current + 1.year, qtd_bas: 1500.0, sit_mod: "A" },
  { cod_mod: "MOD003", ver_mod: 1, des_mod: "Modelo Ração Avícola", uni_med: "KG", dat_ini: Date.current, dat_fim: Date.current + 1.year, qtd_bas: 800.0, sit_mod: "A" },
  { cod_mod: "MOD004", ver_mod: 1, des_mod: "Modelo Fertilizante NPK", uni_med: "KG", dat_ini: Date.current, dat_fim: Date.current + 1.year, qtd_bas: 2000.0, sit_mod: "A" },
  { cod_mod: "MOD005", ver_mod: 1, des_mod: "Modelo Premix Vitamínico", uni_med: "KG", dat_ini: Date.current, dat_fim: Date.current + 1.year, qtd_bas: 500.0, sit_mod: "A" }
]

modelos.each do |modelo|
  ErpModelGeneral.find_or_create_by(cod_mod: modelo[:cod_mod], ver_mod: modelo[:ver_mod]) do |m|
    m.assign_attributes(modelo)
  end
end

puts "⚙️ Criando itens de modelo (relacionando com equipamentos)..."
# Buscar equipamentos existentes para criar os relacionamentos
equipamentos = ErpEquipment.pluck(:cod_eqp)

if equipamentos.any?
  itens_modelo = [
    # MOD001 - Ração Suína
    { cod_mod: "MOD001", ver_mod: 1, seq_mod: 1, cod_cmp: "MILHO001", qtd_uti: 500.0, cod_balanca: equipamentos[0] },
    { cod_mod: "MOD001", ver_mod: 1, seq_mod: 2, cod_cmp: "SOJA001", qtd_uti: 300.0, cod_balanca: equipamentos[1] || equipamentos[0] },
    { cod_mod: "MOD001", ver_mod: 1, seq_mod: 3, cod_cmp: "CALCARIO001", qtd_uti: 50.0, cod_balanca: equipamentos[2] || equipamentos[0] },
    
    # MOD002 - Ração Bovina
    { cod_mod: "MOD002", ver_mod: 1, seq_mod: 1, cod_cmp: "MILHO002", qtd_uti: 700.0, cod_balanca: equipamentos[0] },
    { cod_mod: "MOD002", ver_mod: 1, seq_mod: 2, cod_cmp: "FARELO001", qtd_uti: 400.0, cod_balanca: equipamentos[1] || equipamentos[0] },
    { cod_mod: "MOD002", ver_mod: 1, seq_mod: 3, cod_cmp: "SAL001", qtd_uti: 30.0, cod_balanca: equipamentos[2] || equipamentos[0] },
    
    # MOD003 - Ração Avícola
    { cod_mod: "MOD003", ver_mod: 1, seq_mod: 1, cod_cmp: "MILHO003", qtd_uti: 400.0, cod_balanca: equipamentos[0] },
    { cod_mod: "MOD003", ver_mod: 1, seq_mod: 2, cod_cmp: "SOJA002", qtd_uti: 250.0, cod_balanca: equipamentos[1] || equipamentos[0] },
    { cod_mod: "MOD003", ver_mod: 1, seq_mod: 3, cod_cmp: "VITAMINA001", qtd_uti: 20.0, cod_balanca: equipamentos[2] || equipamentos[0] },
    
    # MOD004 - Fertilizante
    { cod_mod: "MOD004", ver_mod: 1, seq_mod: 1, cod_cmp: "UREIA001", qtd_uti: 800.0, cod_balanca: equipamentos[0] },
    { cod_mod: "MOD004", ver_mod: 1, seq_mod: 2, cod_cmp: "FOSFATO001", qtd_uti: 600.0, cod_balanca: equipamentos[1] || equipamentos[0] },
    { cod_mod: "MOD004", ver_mod: 1, seq_mod: 3, cod_cmp: "POTASSIO001", qtd_uti: 400.0, cod_balanca: equipamentos[2] || equipamentos[0] },
    
    # MOD005 - Premix
    { cod_mod: "MOD005", ver_mod: 1, seq_mod: 1, cod_cmp: "VITAMINAA001", qtd_uti: 100.0, cod_balanca: equipamentos[0] },
    { cod_mod: "MOD005", ver_mod: 1, seq_mod: 2, cod_cmp: "VITAMINAD001", qtd_uti: 80.0, cod_balanca: equipamentos[1] || equipamentos[0] },
    { cod_mod: "MOD005", ver_mod: 1, seq_mod: 3, cod_cmp: "MINERAIS001", qtd_uti: 150.0, cod_balanca: equipamentos[2] || equipamentos[0] }
  ]

  itens_modelo.each do |item|
    ErpModelItem.find_or_create_by(
      cod_mod: item[:cod_mod], 
      ver_mod: item[:ver_mod], 
      seq_mod: item[:seq_mod], 
      cod_cmp: item[:cod_cmp]
    ) do |i|
      i.assign_attributes(item)
    end
  end
else
  puts "⚠️ Nenhum equipamento encontrado. Pulando criação de itens de modelo."
end

puts "🏗️ Criando roteiros gerais..."
roteiros = [
  { cod_rot: "ROT001", ver_rot: 1, des_rot: "Roteiro Produção Ração", qtd_base: 1000.0, lot_tec: 100.0 },
  { cod_rot: "ROT002", ver_rot: 1, des_rot: "Roteiro Produção Fertilizante", qtd_base: 2000.0, lot_tec: 200.0 },
  { cod_rot: "ROT003", ver_rot: 1, des_rot: "Roteiro Produção Premix", qtd_base: 500.0, lot_tec: 50.0 }
]

roteiros.each do |roteiro|
  ErpOperationGeneral.find_or_create_by(cod_rot: roteiro[:cod_rot], ver_rot: roteiro[:ver_rot]) do |r|
    r.assign_attributes(roteiro)
  end
end

puts "📦 Criando produtos ERP..."
produtos = [
  # Produtos da Linha L001
  { cod_pro: "PROD001", des_pro: "Ração Suína Crescimento 18%", cpl_pro: "Ração completa", uni_med: "KG", cod_mod: "MOD001", cod_rot: "ROT001", des_teo: "Ração para suínos em crescimento", cod_cte: "RAC", seq_ccp: 1 },
  { cod_pro: "PROD002", des_pro: "Ração Suína Terminação 16%", cpl_pro: "Ração completa", uni_med: "KG", cod_mod: "MOD001", cod_rot: "ROT001", des_teo: "Ração para suínos em terminação", cod_cte: "RAC", seq_ccp: 2 },
  { cod_pro: "PROD003", des_pro: "Ração Bovina Engorda 14%", cpl_pro: "Ração completa", uni_med: "KG", cod_mod: "MOD002", cod_rot: "ROT001", des_teo: "Ração para bovinos em engorda", cod_cte: "RAC", seq_ccp: 3 },
  
  # Produtos da Linha L002
  { cod_pro: "PROD004", des_pro: "Ração Avícola Postura 17%", cpl_pro: "Ração completa", uni_med: "KG", cod_mod: "MOD003", cod_rot: "ROT001", des_teo: "Ração para aves poedeiras", cod_cte: "RAC", seq_ccp: 4 },
  { cod_pro: "PROD005", des_pro: "Ração Avícola Frango Corte 20%", cpl_pro: "Ração completa", uni_med: "KG", cod_mod: "MOD003", cod_rot: "ROT001", des_teo: "Ração para frangos de corte", cod_cte: "RAC", seq_ccp: 5 },
  
  # Produtos da Linha L003
  { cod_pro: "PROD006", des_pro: "Fertilizante NPK 10-10-10", cpl_pro: "Fertilizante granulado", uni_med: "KG", cod_mod: "MOD004", cod_rot: "ROT002", des_teo: "Fertilizante NPK balanceado", cod_cte: "FER", seq_ccp: 6 },
  { cod_pro: "PROD007", des_pro: "Fertilizante NPK 20-05-20", cpl_pro: "Fertilizante granulado", uni_med: "KG", cod_mod: "MOD004", cod_rot: "ROT002", des_teo: "Fertilizante rico em N e K", cod_cte: "FER", seq_ccp: 7 },
  
  # Produtos sem linha específica (para testar filtro)
  { cod_pro: "PROD008", des_pro: "Premix Vitamínico Suíno", cpl_pro: "Suplemento vitamínico", uni_med: "KG", cod_mod: "MOD005", cod_rot: "ROT003", des_teo: "Premix para suínos", cod_cte: "PRE", seq_ccp: 8 },
  { cod_pro: "PROD009", des_pro: "Premix Vitamínico Bovino", cpl_pro: "Suplemento vitamínico", uni_med: "KG", cod_mod: "MOD005", cod_rot: "ROT003", des_teo: "Premix para bovinos", cod_cte: "PRE", seq_ccp: 9 },
  { cod_pro: "PROD010", des_pro: "Ração Suína Lactação 19%", cpl_pro: "Ração completa", uni_med: "KG", cod_mod: "MOD001", cod_rot: "ROT001", des_teo: "Ração para porcas lactantes", cod_cte: "RAC", seq_ccp: 10 }
]

produtos.each do |produto|
  ErpProduct.find_or_create_by(cod_pro: produto[:cod_pro]) do |p|
    p.assign_attributes(produto)
  end
end

puts "📊 Criando alguns produtos de contingência..."
contingencia_produtos = [
  { cod_pro: "CONT001", des_pro: "Produto Contingência Teste 1", uni_med: "KG" },
  { cod_pro: "CONT002", des_pro: "Produto Contingência Teste 2", uni_med: "L" },
  { cod_pro: "CONT003", des_pro: "Produto Contingência Teste 3", uni_med: "UN" }
]

contingencia_produtos.each do |produto|
  ContingenciaProduct.find_or_create_by(cod_pro: produto[:cod_pro]) do |p|
    p.assign_attributes(produto)
  end
end

User.first_or_create(email: 'facholi@facholi.com', password: 'adas32fav@#!32421')

puts "🎯 Resumo dos dados criados:"
puts "- #{ErpUnityMeasurement.count} unidades de medida"
puts "- #{ErpModelGeneral.count} modelos gerais"
puts "- #{ErpModelItem.count} itens de modelo"
puts "- #{ErpOperationGeneral.count} roteiros"
puts "- #{ErpProduct.count} produtos ERP"
puts "- #{ContingenciaProduct.count} produtos de contingência"
puts "- #{Line.count} linhas (preservadas)"
puts "- #{ErpEquipment.count} equipamentos (preservados)"
puts "- #{EquipmentLine.count} relacionamentos equipamento-linha (preservados)"

puts "✅ Seeds executados com sucesso!"
puts ""
puts "🔍 Para testar o filtro de produtos por linha:"
puts "1. Vá para Ordens de Produção → Cadastro"
puts "2. Selecione uma linha na etapa 1"
puts "3. Na etapa 2, use o filtro por código (ex: 'PROD001', 'PROD004', etc.)"
puts ""
puts "📝 Relacionamentos criados:"
puts "- Produtos PROD001-003 → MOD001/002 → equipamentos → linhas"
puts "- Produtos PROD004-005 → MOD003 → equipamentos → linhas"  
puts "- Produtos PROD006-007 → MOD004 → equipamentos → linhas"
puts "- Produtos PROD008-010 → MOD005 → equipamentos → linhas"