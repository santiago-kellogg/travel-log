require "test_helper"

class PlacesPageTest < ActionDispatch::IntegrationTest
  test "Visiting /places shows a page with the heading \"Places\"." do
    get("/places")

    assert_response(:success)
    assert_select("h1", "Places")
  end

  test "The places page lists the name of every place that has been saved." do
    lisbon = Place.new
    lisbon["name"] = "Lisbon"
    lisbon.save
    kyoto = Place.new
    kyoto["name"] = "Kyoto"
    kyoto.save

    get("/places")

    assert_select("body", /Lisbon/)
    assert_select("body", /Kyoto/)
  end

  test "Each place's name appears in the list as its own item." do
    lisbon = Place.new
    lisbon["name"] = "Lisbon"
    lisbon.save
    kyoto = Place.new
    kyoto["name"] = "Kyoto"
    kyoto.save

    get("/places")

    assert_select("ul li", 2)
    assert_select("li", "Lisbon")
    assert_select("li", "Kyoto")
  end

  test "When no places have been saved, the places page says \"No places yet.\"" do
    get("/places")

    assert_select("p", "No places yet.")
    assert_select("li", 0)
  end
end
