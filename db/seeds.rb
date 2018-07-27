# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
distcom = Distcom.first
if distcom
  puts '分销提成初始化设置已存在，本次忽略'
else
  Distcom.create(distcom:0)
  puts '分销提成初始化设置完成'
end

servicecom = Servicecom.first
if servicecom
  puts '服务提成初始化设置已存在，本次忽略'
else
  Servicecom.create(base:0,percent:0)
  puts '服务提成初始化设置完成'
end