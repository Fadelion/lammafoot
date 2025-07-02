# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "frontend", to: "frontend.js"
pin "nos_terrain", to: "nos_terrain.js"
pin "sinscrire", to: "sinscrire.js"
pin "@rails/ujs", to: "https://cdn.skypack.dev/@rails/ujs"
pin "@stripe/stripe-js", to: "https://cdn.skypack.dev/@stripe/stripe-js"
