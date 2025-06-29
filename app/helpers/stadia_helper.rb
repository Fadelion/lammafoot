module StadiaHelper
  def format_price(price)
    "#{price}€/heure"
  end

  def rating_stars(rating)
    full_stars = rating.to_i
    empty_stars = 5 - full_stars
    
    ('★' * full_stars + '☆' * empty_stars).html_safe
  end
end
