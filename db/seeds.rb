# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name: "Excellara_User_Admin",
            email: "admin@excellara.com",
            password: "excellara",
            password_confirmation: "excellara",
            location: "Palo Alto",
            accomplishment: "Taking the world by storm",
            experience: "Working on it.",
            admin: true)

Company.create!(name: "Excellara_Company_Admin",
             email: "admin2@excellara.com",
             password: "excellara",
             password_confirmation: "excellara",
             location: "Palo Alto",
             description: "Taking the world by storm",
             size: 3,
             admin: true)