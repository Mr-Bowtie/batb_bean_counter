require "test_helper"

class PaymentSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_source = payment_sources(:one)
  end

  test "should get index" do
    get payment_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_source_url
    assert_response :success
  end

  test "should create payment_source" do
    assert_difference("PaymentSource.count") do
      post payment_sources_url, params: { payment_source: {} }
    end

    assert_redirected_to payment_source_url(PaymentSource.last)
  end

  test "should show payment_source" do
    get payment_source_url(@payment_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_source_url(@payment_source)
    assert_response :success
  end

  test "should update payment_source" do
    patch payment_source_url(@payment_source), params: { payment_source: {} }
    assert_redirected_to payment_source_url(@payment_source)
  end

  test "should destroy payment_source" do
    assert_difference("PaymentSource.count", -1) do
      delete payment_source_url(@payment_source)
    end

    assert_redirected_to payment_sources_url
  end
end
