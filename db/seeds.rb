# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ship_types = [
  [ 2, 'Destroyer' ],
  [ 3, 'Cruiser' ],
  [ 3, 'Submarine' ],
  [ 4, 'Battleship' ],
  [ 5, 'Carrier' ]
]

ship_types.each do |size, name|
  ShipType.create( name: name, size: size )
end
