module BookingsHelper
  def booking_status_badge(status)
    case status
    when 'pending'
      content_tag :span, status.capitalize, class: 'badge bg-warning'
    when 'confirmed'
      content_tag :span, status.capitalize, class: 'badge bg-success'
    when 'cancelled'
      content_tag :span, status.capitalize, class: 'badge bg-danger'
    when 'completed'
      content_tag :span, status.capitalize, class: 'badge bg-info'
    else
      content_tag :span, status.capitalize, class: 'badge bg-secondary'
    end
  end
end
