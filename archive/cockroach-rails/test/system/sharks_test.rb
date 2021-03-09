require "application_system_test_case"

class SharksTest < ApplicationSystemTestCase
  setup do
    @shark = sharks(:one)
  end

  test "visiting the index" do
    visit sharks_url
    assert_selector "h1", text: "Sharks"
  end

  test "creating a Shark" do
    visit sharks_url
    click_on "New Shark"

    fill_in "Facts", with: @shark.facts
    fill_in "Name", with: @shark.name
    click_on "Create Shark"

    assert_text "Shark was successfully created"
    click_on "Back"
  end

  test "updating a Shark" do
    visit sharks_url
    click_on "Edit", match: :first

    fill_in "Facts", with: @shark.facts
    fill_in "Name", with: @shark.name
    click_on "Update Shark"

    assert_text "Shark was successfully updated"
    click_on "Back"
  end

  test "destroying a Shark" do
    visit sharks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shark was successfully destroyed"
  end
end
