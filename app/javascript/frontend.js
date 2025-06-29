// Frontend JavaScript

// Carrousel automatique
document.addEventListener("DOMContentLoaded", function () {
  const items = document.querySelectorAll(".carousel-item");
  let current = 0;

  function showItem(index) {
    items.forEach((img, i) => {
      img.classList.toggle("active", i === index);
    });
  }

  if (items.length > 0) {
    setInterval(() => {
      current = (current + 1) % items.length;
      showItem(current);
    }, 3500); // Change toutes les 3,5 secondes

    showItem(current);
  }
});

// Filtrage des terrains
function filtrerTerrains() {
  const filtre = document.getElementById('filtreLocalisation');
  if (filtre) {
    const valeur = filtre.value.toLowerCase();
    const terrains = document.querySelectorAll('.conponet');
    
    terrains.forEach(terrain => {
      const titre = terrain.querySelector('h5').textContent.toLowerCase();
      const description = terrain.querySelector('p').textContent.toLowerCase();
      
      if (titre.includes(valeur) || description.includes(valeur)) {
        terrain.style.display = 'block';
      } else {
        terrain.style.display = 'none';
      }
    });
  }
}

// Carrousel automatique Bootstrap
window.addEventListener('DOMContentLoaded', function () {
  var carousel = document.querySelector('#carouselExampleDark');
  if (carousel && window.bootstrap && bootstrap.Carousel) {
    new bootstrap.Carousel(carousel, {
      interval: 9000,
      ride: 'carousel',
      pause: false,
      wrap: true
    });
  }
});

// Fonction générique pour afficher/masquer les images médias sociaux au survol de chaque icône
function toggleMediaSocialHero() {
  const pairs = [
    ['.mouse-resaeux', '.media-social-euro'],
    ['.monstreReseauInsta', '.mediaSocialInsta'],
    ['.monstreReseauLink', '.mediaSocialLINK'],
    ['.monstreReseauTiktok', '.mediaSocialTiktok']
  ];

  pairs.forEach(([iconClass, mediaClass]) => {
    const icon = document.querySelector(iconClass);
    const media = document.querySelector(mediaClass);
    if (icon && media) {
      icon.addEventListener('mouseenter', function () {
        icon.style.display = 'none';
        media.style.display = 'flex';
      });
      media.addEventListener('mouseleave', function () {
        media.style.display = 'none';
        icon.style.display = 'flex';
      });
    }
  });
}

// Gestion du modal de réservation
function setupReservationModal() {
  const reservationButtons = document.querySelectorAll('.button-resever');
  const modalTitle = document.getElementById('reservationModalLabel');
  const stadiumIdField = document.getElementById('modal_stadium_id');
  
  reservationButtons.forEach(button => {
    button.addEventListener('click', function() {
      const stadiumId = this.getAttribute('data-stadium-id');
      const stadiumName = this.getAttribute('data-stadium-name');
      
      if (modalTitle && stadiumName) {
        modalTitle.textContent = `Réservation ${stadiumName}`;
      }
      
      if (stadiumIdField && stadiumId) {
        stadiumIdField.value = stadiumId;
      }
    });
  });
}

// Initialisation au chargement de la page
window.addEventListener('DOMContentLoaded', function() {
  toggleMediaSocialHero();
  setupReservationModal();
});

// Fonction pour les alertes de réservation (conservée pour compatibilité)
function reserverTerrain(terrainId) {
  alert(`Redirection vers la réservation du terrain ${terrainId}`);
}