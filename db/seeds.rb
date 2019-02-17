User.create!(name:  "Phan Hướng",
             email: "phanvanhuong241097@gmail.com",
             password: "huong24101997",
             password_confirmation: "huong24101997",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
