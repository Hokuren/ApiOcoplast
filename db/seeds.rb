# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Product.create(name: 'Rimax',cost: 0,weight: 0,product_id: 1)
Product.create(name: 'Tapas de Gaseosa',cost: 0,weight: 0,product_id: 2)
Product.create(name: 'Pasta',cost: 0,weight: 0,product_id: 3)
Product.create(name: 'Canasta',cost: 0,weight: 0,product_id: 4)

Product.create(name: 'Rimax-Pasta',cost: 0,weight: 0,product_id: 1) # 5
Product.create(name: 'Tapas de Gaseosa-Pasta',cost: 0,weight: 0,product_id: 2) # 6
Product.create(name: 'Canasta-Pasta',cost: 0,weight: 0,product_id: 4) # 7

Treatment.create(name: 'Molido 1')
Treatment.create(name: 'Molido 2')
Treatment.create(name: 'Molido 3')

Phase.create(name: 'Inventario en Bruto')
Phase.create(name: 'Fase 1')
Phase.create(name: 'Fase 2')
Phase.create(name: 'Fase 3')            