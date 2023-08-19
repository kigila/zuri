defmodule ZuriWeb.ErrorJSONTest do
  use ZuriWeb.ConnCase, async: true

  test "renders 404" do
    assert ZuriWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ZuriWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
