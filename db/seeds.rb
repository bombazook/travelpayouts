# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

programs = [
  {
    "title": 'Aviasales / Jetradar',
    "description": 'Поиск дешевых авиабилетов'
  },
  {
    "title": 'Hotellook',
    "description": 'Бронирование отелей со скидками до 60%. Забронируйте номер по выгодной цене!'
  },
  {
    "title": 'Discover Cars',
    "description": 'Аренда автомобилей по всему миру'
  },
  {
    "title": 'Hostelworld',
    "description": 'Хостелы по всему миру'
  },
  {
    "title": 'Trainline',
    "description": 'Поиск, сравнение и покупка билетов на автобусы и поезда по Европе'
  },
  {
    "title": 'Kiwi.com',
    "description": 'Дешёвые билеты на самолёты'
  }
]

programs.each { |attributes| Program.create(attributes) }
