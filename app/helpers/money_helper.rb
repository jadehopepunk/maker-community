module MoneyHelper
  def format_money(amount, show_zero: false)
    return nil if amount == 0 && !show_zero

    show_cents = amount % 1 != 0
    number_to_currency(amount, precision: (show_cents ? 2 : 0))
  end
end
