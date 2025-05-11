require "application_system_test_case"

class PaymentSourcesTest < ApplicationSystemTestCase
  setup do
    @payment_source = payment_sources(:one)
  end

  test "visiting the index" do
    visit payment_sources_url
    assert_selector "h1", text: "Payment sources"
  end

  test "should create payment source" do
    visit payment_sources_url
    click_on "New payment source"

    click_on "Create Payment source"

    assert_text "Payment source was successfully created"
    click_on "Back"
  end

  test "should update Payment source" do
    visit payment_source_url(@payment_source)
    click_on "Edit this payment source", match: :first

    click_on "Update Payment source"

    assert_text "Payment source was successfully updated"
    click_on "Back"
  end

  test "should destroy Payment source" do
    visit payment_source_url(@payment_source)
    click_on "Destroy this payment source", match: :first

    assert_text "Payment source was successfully destroyed"
  end
end
