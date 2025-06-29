import { Controller } from "@hotwired/stimulus"
import { loadStripe } from "@stripe/stripe-js"

export default class extends Controller {
  static targets = ["duration", "total", "cardElement", "cardErrors"]

  connect() {
    // Initialisation de Stripe
    this.stripePromise = loadStripe('<your-publishable-key>')
    
    // Calcul dynamique du prix
    this.calculatePrice()
    
    document.getElementById('booking_start_time').addEventListener('change', this.calculatePrice.bind(this))
    document.getElementById('booking_end_time').addEventListener('change', this.calculatePrice.bind(this))
  }

  calculatePrice() {
    const startTime = new Date(document.getElementById('booking_start_time').value)
    const endTime = new Date(document.getElementById('booking_end_time').value)
    
    if (startTime && endTime && startTime < endTime) {
      const duration = (endTime - startTime) / (1000 * 60 * 60) // Durée en heures
      const pricePerHour = parseFloat('<%= @pitch.price_per_hour %>')
      const total = duration * pricePerHour
      
      this.durationTarget.textContent = duration.toFixed(1)
      this.totalTarget.textContent = `€${total.toFixed(2)}`
    }
  }

  async submitForm(e) {
    e.preventDefault()
    
    const stripe = await this.stripePromise
    const elements = stripe.elements()
    const cardElement = elements.create('card')
    
    cardElement.mount('#card-element')
    
    const { error, paymentMethod } = await stripe.createPaymentMethod({
      type: 'card',
      card: cardElement,
    })
    
    if (error) {
      this.cardErrorsTarget.textContent = error.message
    } else {
      // Ajoutez le payment_method_id au formulaire avant soumission
      const form = e.target
      const hiddenInput = document.createElement('input')
      hiddenInput.setAttribute('type', 'hidden')
      hiddenInput.setAttribute('name', 'payment_method')
      hiddenInput.setAttribute('value', paymentMethod.id)
      form.appendChild(hiddenInput)
      
      form.submit()
    }
  }
}
