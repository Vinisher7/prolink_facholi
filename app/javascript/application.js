// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Desabilitar Turbo completamente para evitar conflitos
Turbo.session.drive = false

// Desabilitar todos os eventos do Turbo
document.addEventListener('turbo:before-visit', (event) => {
  event.preventDefault()
})

document.addEventListener('turbo:visit', (event) => {
  event.preventDefault()
})
