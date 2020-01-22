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

Period.create(period: "01/2019", month: 1, year: 2019, start_period: "2019-01-01 05:00:00", end_period: "2019-01-31 05:00:00")

Phase.create(name: 'Inventario en Bruto') ### 1
Phase.create(name: 'Clasificacion')       ### 2
Phase.create(name: 'Aglutinar')           ### 3
Phase.create(name: 'Lavar')               ### 4 
Phase.create(name: 'Moler')               ### 5
Phase.create(name: 'Pool')                ### 6  ### OJO                


Cost.create(name: 'TOTAL TRANSPORTE MES (incluyendo sueldo)',cost: 4000000)                   ### 1
Cost.create(name: 'TOTAL PAGADO ENERGÍA - BODEGA LOS LAGOS',cost: 14000000)                   ### 2
Cost.create(name: 'TOTAL PAGADO ENERGÍA - BODEGA ZONA FRANCA',cost: 900000)                   ### 3
Cost.create(name: 'TOTAL PAGADO AGUA',cost: 12000)                                            ### 4 
Cost.create(name: 'ANA MARÍA',cost: 1600000)                                                  ### 5
Cost.create(name: 'COTEROS',cost: 1500000)                                                    ### 6
Cost.create(name: 'MANO DE OBRA CLASIFICACIÓN Y ALISTAMIENTO (SELECCIÓN Y PICADO)',cost: 200) ### 7 ### OJO
Cost.create(name: 'Mano de obra op3 (limpieza, alistamiento y aglutinado)',cost: 1300000)     ### 8
Cost.create(name: 'Dotación y EPP op3',cost: 41667)                                           ### 9
Cost.create(name: 'Mano de obra op2 (30% único operador))',cost: 1300000)                     ### 10
Cost.create(name: 'Dotación y EPP op2',cost: 50000)                                           ### 11
Cost.create(name: 'Insumos de lavado',cost: 41666.6666666667)                                 ### 12
Cost.create(name: 'Repuestos y mtto',cost: 70000)                                             ### 13
Cost.create(name: 'Costo asignado op1',cost: 1300000)                                         ### 14
Cost.create(name: 'Repuestos y mtto',cost: 1300000)                                           ### 15



PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 15, period_id: 1, cost_id: 1, phase_id: 1)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 18, period_id: 1, cost_id: 5, phase_id: 1)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 12, period_id: 1, cost_id: 6, phase_id: 1)
PeriodCostPhase.create(type_cost: 'multiply',period_id: 1, cost_id: 7 , phase_id: 1)

PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 3, period_id: 1, cost_id: 1, phase_id: 3)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 5, period_id: 1, cost_id: 8, phase_id: 3)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 5, period_id: 1, cost_id: 9, phase_id: 3)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: "0.2", period_id: 1, cost_id: 3, phase_id: 3)

PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 30, period_id: 1, cost_id: 10, phase_id: 4)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: "1.04", period_id: 1, cost_id: 2, phase_id: 4)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: "0.39", period_id: 1, cost_id: 2, phase_id: 4)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: "11.7", period_id: 1, cost_id: 4, phase_id: 4)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 100, period_id: 1, cost_id: 11, phase_id: 4)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 30, period_id: 1, cost_id: 12, phase_id: 4)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 100, period_id: 1, cost_id: 13, phase_id: 4)

PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 8, period_id: 1, cost_id: 2, phase_id: 5)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 100, period_id: 1, cost_id: 14, phase_id: 5)
PeriodCostPhase.create(type_cost: 'porcentage',porcentage: 100, period_id: 1, cost_id: 15, phase_id: 5)




