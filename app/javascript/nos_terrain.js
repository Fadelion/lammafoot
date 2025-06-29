 document.getElementById('formReservation').addEventListener('submit', function(e) {
    e.preventDefault();
    alert("Votre réservation a été enregistrée avec succès !");
    const modal = bootstrap.Modal.getInstance(document.getElementById('reservationModal'));
    modal.hide();
    this.reset();
  });


//   ---------POP-------

  function openModal() {
      document.getElementById('modal3D').style.display = 'flex';
    }
    function closeModal() {
      document.getElementById('modal3D').style.display = 'none';
    }


//   ----------3D---------

let scene, camera, renderer, controls;
  let autoRotateAngle = 0;

  init();
  animate();

  function init() {
    scene = new THREE.Scene();

    camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.set(0, 80, 120);

    renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.getElementById("scene-container").appendChild(renderer.domElement);

    controls = new THREE.OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.enableZoom = true;

    const light = new THREE.AmbientLight(0xffffff, 1);
    scene.add(light);

    const grassColor = 0x228B22; // Couleur gazon réaliste

    const field = new THREE.Mesh(
      new THREE.PlaneGeometry(105, 68),
      new THREE.MeshPhongMaterial({ color: grassColor, side: THREE.DoubleSide })
    );
    field.rotation.x = -Math.PI / 2;
    scene.add(field);

    const lineMaterial = new THREE.LineBasicMaterial({ color: 0xffffff });

    const contourPoints = [
      [-52.5, 34], [52.5, 34], [52.5, -34], [-52.5, -34], [-52.5, 34]
    ].map(([x, z]) => new THREE.Vector3(x, 0.1, z));

    const contourGeometry = new THREE.BufferGeometry().setFromPoints(contourPoints);
    const contour = new THREE.Line(contourGeometry, lineMaterial);
    scene.add(contour);

    const circleRadius = 9.15;
    const circleGeometry = new THREE.CircleGeometry(circleRadius, 64);
    const circleEdges = new THREE.EdgesGeometry(circleGeometry);
    const circleLine = new THREE.LineSegments(circleEdges, lineMaterial);
    circleLine.rotation.x = -Math.PI / 2;
    scene.add(circleLine);

    const goalMaterial = new THREE.MeshBasicMaterial({ color: 0xffffff });
    const goalGeometry = new THREE.BoxGeometry(7.32, 2.44, 0.2);

    const goal1 = new THREE.Mesh(goalGeometry, goalMaterial);
    goal1.position.set(0, 1.22, 34);
    scene.add(goal1);

    const goal2 = goal1.clone();
    goal2.position.set(0, 1.22, -34);
    scene.add(goal2);
  }

  function animate() {
    requestAnimationFrame(animate);

    autoRotateAngle += 0.002;
    const radius = 120;
    camera.position.x = radius * Math.sin(autoRotateAngle);
    camera.position.z = radius * Math.cos(autoRotateAngle);
    camera.lookAt(0, 0, 0);

    controls.update();
    renderer.render(scene, camera);
  }

  window.addEventListener("resize", () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
  });