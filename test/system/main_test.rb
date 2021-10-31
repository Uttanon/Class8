require "application_system_test_case"

class MainTest < ApplicationSystemTestCase
  test "login success" do
    visit "/main"
    fill_in "Email", with: "u1"
    fill_in "Password", with: "1234"
    click_on "Login"
    assert_selector "p", text: "Login successfully."
  end
  test "login wrong email" do
    visit "/main"
    fill_in "Email", with: "u"
    fill_in "Password", with: "1234"
    click_on "Login"
    assert_selector "p", text: "Email/Password incorrect."
  end
  test "login wrong password" do
    visit "/main"
    fill_in "Email", with: "u1"
    fill_in "Password", with: "1235"
    click_on "Login"
    assert_selector "p", text: "Email/Password incorrect."
  end
  test "likefeed" do
    visit "/main"
    fill_in "Email", with: "u1"
    fill_in "Password", with: "1234"
    click_on "Login"
    find("html body div.container div.container div.row div.col div.col div.col form.button_to input.btn.btn-outline-primary").click
    assert_selector "p", text: "Liked!"
  end
end
