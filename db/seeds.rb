# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# super-admin
User.create!(email: 'jrpolidario@gmail.com', password: 'letsplayadj', is_admin: true)

Category.create!(name: 'Animal')
Category.create!(name: 'Character')
Category.create!(name: 'Brand')
Category.create!(name: 'Furniture')
Category.create!(name: 'Fruit')
Category.create!(name: 'Food')
