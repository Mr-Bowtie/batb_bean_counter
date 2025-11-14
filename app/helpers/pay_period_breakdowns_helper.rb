module PayPeriodBreakdownsHelper
  def allocation_tile(label, amount, color_class: "has-text-info")
    content_tag(:div, class: "cell allocation-tile has-text-centered") do
      concat content_tag(:p, label, class: "has-text-weight-semibold")
      concat content_tag(:p, "$#{currencyDecorator(amount)}", class: color_class)
    end
  end
end
