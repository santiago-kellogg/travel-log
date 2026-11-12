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

  test "The places page has a link to the form for adding a place." do
    get("/places")

    assert_select("a[href='/places/new']")
  end

  test "Visiting /places/new shows a form with a name field and an \"Add place\" button." do
    get("/places/new")

    assert_response(:success)
    assert_select("form[action='/places'][method='post']") do
      assert_select("input[name='name']")
      assert_select("button", "Add place")
    end
  end

  test "Submitting the form creates a place with the name that was entered." do
    post("/places", :params => { "name" => "Lisbon" })

    assert_equal(1, Place.count)
    assert_equal("Lisbon", Place.last["name"])
  end

  test "After submitting, the user lands on /places and sees the new place's name in the list." do
    post("/places", :params => { "name" => "Lisbon" })

    assert_redirected_to("/places")
    follow_redirect!
    assert_select("li", "Lisbon")
  end
end
