# Refunds a theater ticket and notifies the buyer.
class RefundTicket
  def initialize(ticket, mailer)
    @ticket = ticket
    @mailer = mailer
  end

  def call
    return false if @ticket.refunded?

    @ticket.update!(refunded: true)
    notify_buyer
    true
  end

  def notify_buyer
    @mailer.deliver(@ticket.buyer_email, "Your ticket #{@ticket.id} was refunded")
  end

  def refundable_amount
    @ticket.price - @ticket.fee
  end
end
