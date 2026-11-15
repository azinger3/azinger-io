require "test_helper"

class ProductsNavigationTest < ActionDispatch::IntegrationTest
  test "shared navigation links to home and social profiles on every page" do
    [ root_path, products_path, it_asset_lifecycle_path ].each do |path|
      get path
      assert_response :success
      assert_select "nav[aria-label=?]", "Main navigation" do
        assert_select "a[href=?][aria-label=?]", root_path, "azinger.io home"
        assert_select "a[href=?][target=?][rel~=noopener][aria-label=?] svg",
          "https://github.com/azinger3", "_blank", "GitHub (opens in a new tab)"
        assert_select "a[href=?][target=?][rel~=noopener][aria-label=?] svg",
          "https://linkedin.com/in/rob-azinger", "_blank", "LinkedIn (opens in a new tab)"
      end
    end
  end

  test "visitors can navigate from home to the product insight and back" do
    get root_path
    assert_response :success
    assert_select "a[href=?][aria-label=?]", products_path, "Products"

    get products_path
    assert_response :success
    assert_select "h1", "Products."
    assert_select ".product-grid li", 10
    assert_select ".product-grid a[href=?]", it_asset_lifecycle_path, 1
    assert_select ".product-grid a", 1

    get it_asset_lifecycle_path
    assert_response :success
    assert_select "h1", /Internal IT fulfillment/
    assert_select ".insight-card h2", "The problem"
    assert_select ".insight-card h2", "The solution"
    assert_select ".insight-card" do
      assert_select "h2", "Imaging, refresh & disposal"
      assert_select "p", /automated imaging and provisioning/
      assert_select "p", /DoD GDisk wiping in our onsite lab/
    end
    assert_select "a[href=?]", products_path, text: /Back to Products/
  end
end
