module CpfFormatter
  module_function

  def strip(cpf)
    cpf.to_s.gsub(/[^0-9]/, '')
  end

  def format(cpf)
    numbers = strip(cpf)
    return cpf unless numbers.length == 11

    "#{numbers[0..2]}.#{numbers[3..5]}.#{numbers[6..8]}-#{numbers[9..10]}"
  end

  def mask(cpf)
    numbers = strip(cpf)
    return cpf unless numbers.length == 11

    "***.#{numbers[3..5]}.#{numbers[6..8]}-**"
  end

  def valid?(cpf)
    numbers = strip(cpf)
    return false unless numbers.length == 11
    return false if numbers.chars.uniq.length == 1

    digits = numbers.chars.map(&:to_i)
    [9, 10].all? do |index|
      sum = (0...index).sum { |i| digits[i] * (index + 1 - i) }
      check = (sum * 10) % 11
      check = 0 if check == 10
      check == digits[index]
    end
  end
end
