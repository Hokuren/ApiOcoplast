# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Product.create(name: 'Rimax',cost: 0,weight: 0,product_id: 1) #1
Product.create(name: 'Tapas de Gaseosa',cost: 0,weight: 0,product_id: 2) #2
Product.create(name: 'Pasta',cost: 0,weight: 0,product_id: 3) #3
Product.create(name: 'Canasta',cost: 0,weight: 0,product_id: 4) #4
Product.create(name: 'Rimax-Pasta',cost: 0,weight: 0,product_id: 1) #5 
Product.create(name: 'Tapas de Gaseosa-Pasta',cost: 0,weight: 0,product_id: 2) #6 
Product.create(name: 'Canasta-Pasta',cost: 0,weight: 0,product_id: 4)  #7
Product.create(name: 'Aglutinado 1',cost: 0,weight: 0,product_id: 8)  #8
Product.create(name: 'Soplado 1',cost: 0,weight: 0,product_id: 9)  #9
Product.create(name: 'Soplado 2',cost: 0,weight: 0,product_id: 10)  #10
Product.create(name: 'Tapa',cost: 0,weight: 0,product_id: 11)  #11
Product.create(name: 'POLIPROPILENO (PP)',cost: 0,weight: 0,product_id: 12)  #12
Product.create(name: 'POLIETILENO (PL)',cost: 0,weight: 0,product_id: 13)  #13

Treatment.create(name: 'Costo asignado total transporte mes pasta', minimal_cost: 0, maximum_cost: 1000)
Treatment.create(name: 'Costo asignado total consumo energía molino', minimal_cost: 0, maximum_cost: 2000)
Treatment.create(name: 'Costo asignado total consumo energía lavadoras', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado total consumo energía molino de torta', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado total consumo energía aglutinadora', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado total consumo energía herramientas estibas', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado total consumo de agua lavadoras', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado (%de ocupación*sueldo)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado (%de ocupación coteros*sueldo)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado TRANSPORTE (%de ocupación transporte*transporte total mes)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado COTEROS (%de ocupación COTEROS AGLUTINAR*TOTAL PAGADO COTEROS mes)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignadon op3 (% ocupación op3 * Sueldo)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado energía aglutinado 1 (costo asignado total aglutinadora * %aglutinado 1)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Cantidad a lavar (% de material a lavar * cantidad neta clasificada)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignadon op2 (% ocupación op2 * Sueldo)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Energía (c. asignado molino + c. asignado lavadoras)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asginado energía molino (costo asignado total consumo energía molino * %material a lavar)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado energía lavadoras (costo asignado total consumo energía lavadoras * %material a lavar)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado agua lavadoras', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op1', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Mano de obra  moler soplado', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op1 (Sueldo * %soplado)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op2 (Sueldo * %soplado)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado energía molino (costo asignado total consumo energía molino * %soplado)', minimal_cost: 0, maximum_cost: 3000)
#Treatment.create(name: 'Mano de obra  moler tapa 2', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op1 (Sueldo * %tapa)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op2 (Sueldo * %tapa)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado energía molino (costo asignado total consumo energía molino * %tapa)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Cantidad (kg)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op1 (Sueldo * %PP)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op2 (Sueldo * %PP)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado energía molino (costo asignado total consumo energía molino * %PP)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op1 (Sueldo * %PL)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado op2 (Sueldo * %PL)', minimal_cost: 0, maximum_cost: 3000)
Treatment.create(name: 'Costo asignado energía molino (costo asignado total consumo energía molino * %PL)', minimal_cost: 0, maximum_cost: 3000)



Phase.create(name: 'Inventario en Bruto')
Phase.create(name: 'Fase 1')
Phase.create(name: 'Fase 2')
Phase.create(name: 'Fase 3') 
Phase.create(name: 'Pool')           