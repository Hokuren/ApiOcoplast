# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Product.create(name: 'Rimax',cost: 0,weight: 0)

Treatment.create(name: 'Molido 1')
Treatment.create(name: 'Molido 2')
Treatment.create(name: 'Molido 3')

Phase.create(name: 'Fase 0')
Phase.create(name: 'Fase 1')
Phase.create(name: 'Fase 2')            