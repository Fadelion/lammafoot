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

// Fonction pour les alertes de réservation
function reserverTerrain(terrainId) {
  alert(`Redirection vers la réservation du terrain ${terrainId}`);
  // Ici vous pouvez ajouter la logique de redirection vers la page de réservation
}