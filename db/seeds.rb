# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Réinitialiser les tables pour éviter les doublons
puts "Cleaning database..."
Payment.destroy_all
Review.destroy_all
Booking.destroy_all
Stadium.destroy_all
User.destroy_all

# Create admin user
admin = User.create!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@lammafoot.com",
  password: "password123",
  role: "admin"
)

puts "Admin user created: #{admin.email}"

# Create regular users
regular_users = []
5.times do |i|
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "user#{i+1}@example.com",
    password: "password123"
  )
  regular_users << user
  puts "Regular user created: #{user.email}"
end

# Create stadia
stadia_data = [
  {
    name: "Stade Municipal",
    location: "Centre-ville",
    price: 80.0,
    capacity: 22,
    description: "Un stade moderne situé en plein centre-ville, facilement accessible en transport en commun."
  },
  {
    name: "Complexe Sportif Nord",
    location: "Quartier Nord",
    price: 65.0,
    capacity: 18,
    description: "Terrain synthétique de dernière génération avec vestiaires et douches."
  },
  {
    name: "Arena Football Club",
    location: "Zone Industrielle Est",
    price: 120.0,
    capacity: 30,
    description: "Grand complexe avec plusieurs terrains, idéal pour les tournois et grands événements."
  },
  {
    name: "Stade Universitaire",
    location: "Campus Central",
    price: 50.0,
    capacity: 16,
    description: "Terrain bien entretenu sur le campus universitaire, parfait pour les matchs amicaux."
  },
  {
    name: "Five Football Center",
    location: "Périphérie Sud",
    price: 90.0,
    capacity: 10,
    description: "Terrains de football à 5 couverts, disponibles même en cas de mauvais temps."
  }
]

created_stadia = []
stadia_data.each do |stadium_data|
  stadium = Stadium.create!(stadium_data)
  created_stadia << stadium
  puts "Stadium created: #{stadium.name}"
end

# Create past bookings and reviews (ensuring each user-stadium pair is unique for reviews)
user_stadium_pairs = []

10.times do |i|
  # Ensure we don't run out of users
  user_index = i % regular_users.length
  user = regular_users[user_index]

  # Ensure we don't run out of stadia
  stadium_index = i % created_stadia.length
  stadium = created_stadia[stadium_index]

  # Create a unique booking for each iteration
  start_date = Faker::Time.between(from: 1.month.ago, to: 1.day.ago)
  end_date = start_date + 2.hours

  booking = Booking.create!(
    user: user,
    stadium: stadium,
    start_date: start_date,
    end_date: end_date,
    status: "completed"
  )

  # Create payment for the booking
  Payment.create!(
    user: user,
    booking: booking,
    amount: booking.total_price,
    payment_date: start_date - 2.days,
    payment_method: [ "credit_card", "paypal", "bank_transfer" ].sample,
    status: "completed"
  )

  # Create review only if this user-stadium pair hasn't been used yet
  pair = [ user.id, stadium.id ]
  unless user_stadium_pairs.include?(pair)
    Review.create!(
      user: user,
      stadium: stadium,
      rating: rand(3..5),
      comment: Faker::Lorem.paragraph(sentence_count: 2)
    )
    user_stadium_pairs << pair
    puts "Review created for #{user.email} on #{stadium.name}"
  end

  puts "Past booking created for #{user.email} at #{stadium.name}"
end

# Future bookings (no reviews for future bookings)
5.times do |i|
  user = regular_users[i % regular_users.length]
  stadium = created_stadia[i % created_stadia.length]

  start_date = Faker::Time.between(from: 1.day.from_now, to: 1.month.from_now)
  end_date = start_date + 2.hours

  booking = Booking.create!(
    user: user,
    stadium: stadium,
    start_date: start_date,
    end_date: end_date,
    status: "confirmed"
  )

  # Create payment for the booking
  Payment.create!(
    user: user,
    booking: booking,
    amount: booking.total_price,
    payment_date: Time.current,
    payment_method: [ "credit_card", "paypal", "bank_transfer" ].sample,
    status: "completed"
  )

  puts "Future booking created for #{user.email} at #{stadium.name}"
end

puts "Seed data created successfully!"
