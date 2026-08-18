puts 'Creating user...'
User.destroy_all

user_1 = User.new(nickname: "Ayaka", email:"ayaka@email.com", password: "secret1")
user_1.save!
user_2 = User.new(nickname: "Kylie", email:"kylie@email.com", password: "secret2")
user_2.save!
user_3 = User.new(nickname: "Drew", email:"drew@email.com", password: "secret3")
user_3.save!

ui_kit_1 = UiKit.new(name: "Christmas", description: "Christmas theme. Cute!", user: user_1)
ui_kit_1.save
ui_kit_2 = UiKit.new(name: "Business", description: "Business theme. Cool!", user: user_2)
ui_kit_2.save

component_1 = Component.new(category: "button", html_code: '<a class="btn btn-ghost" href="#">Write a story</a>',
css_code: '.btn-ghost {
  color: #4A4A4A;
  border: 1px solid #4A4A4A;
  padding: 8px 24px;
  border-radius: 50px;
  font-weight: lighter;
  opacity: 0.6;
  transition: opacity 0.3s ease;
}

.btn-ghost:hover {
  opacity: 1;
}',
ui_kit: ui_kit_1
)
component_1.save
component_2 = Component.new(category: "button", html_code: '<a class="btn btn-flat" href="#">Book now</a>',
css_code: '.btn-flat {
  color: white;
  padding: 8px 24px;
  border-radius: 4px;
  background: #670BFF;
  transition: background 0.3s ease;
}

.btn-flat:hover {
  background: #4D04C4;
  color: white;
}',
ui_kit: ui_kit_2
)
component_2.save
puts 'Finished!'
