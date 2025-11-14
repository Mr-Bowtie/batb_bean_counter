module ApplicationHelper
  def currencyDecorator(input)
    input = input.to_s
    return "0.00" if input.blank?

    if input.length == 1
      "0.0#{input}"
    elsif input.length == 2
      "0.#{input}"
    else
      "#{input[0..-3]}.#{input[-2..]}"
    end
  end
end
