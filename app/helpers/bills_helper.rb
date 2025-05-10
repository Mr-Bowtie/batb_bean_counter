module BillsHelper
  def currencyDecorator(input)
    input = input.to_s
    if input.length < 1
      return "0.00"
    elsif input.length == 1
      return "0.0" + input
    elsif input.length == 2
      return "0." + input
    else
      return input[0..-2] + "." + input [-2..]
    end
  end
end
