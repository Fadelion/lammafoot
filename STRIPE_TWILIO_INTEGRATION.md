# Intégration Stripe et Twilio - FootHall

## Résumé des nouvelles fonctionnalités

Ce document décrit l'intégration de Stripe pour les paiements et Twilio pour les communications SMS dans l'application FootHall.

## Fonctionnalités Stripe implémentées

### 1. Paiement par carte bancaire
- **Stripe Checkout** : Interface de paiement sécurisée
- **Gestion des sessions** : Création et validation des sessions de paiement
- **Webhooks** : Traitement automatique des événements de paiement
- **Métadonnées** : Association des paiements aux réservations

### 2. Intégration dans le flux de réservation
- **Page de paiement** : Choix entre Stripe et paiements mobiles traditionnels
- **Confirmation automatique** : Mise à jour du statut de réservation après paiement
- **Gestion d'erreurs** : Traitement des échecs de paiement

### 3. Sécurité
- **Validation des webhooks** : Vérification des signatures Stripe
- **Protection CSRF** : Exemption pour les webhooks
- **Gestion des erreurs** : Logging et traitement des exceptions

## Fonctionnalités Twilio implémentées

### 1. SMS de confirmation
- **Confirmation de réservation** : SMS automatique après paiement réussi
- **Détails de la réservation** : Terrain, date, heure inclus dans le SMS
- **Personnalisation** : Messages adaptés au nom de l'utilisateur

### 2. SMS de rappel
- **Rappels automatiques** : SMS envoyé 24h avant la réservation
- **Job en arrière-plan** : Traitement asynchrone des rappels
- **Programmation intelligente** : Évite les rappels pour les réservations passées

### 3. Gestion des numéros de téléphone
- **Champ optionnel** : Ajout du phone_number au modèle User
- **Formulaire d'inscription** : Possibilité d'ajouter son numéro
- **Validation** : Vérification de la présence du numéro avant envoi SMS

## Architecture technique

### Services créés
1. **StripeService** : Gestion des paiements Stripe
   - Création de sessions checkout
   - Récupération de sessions
   - Création de PaymentIntent

2. **TwilioService** : Gestion des SMS
   - Envoi de SMS génériques
   - SMS de confirmation de réservation
   - SMS de rappel

### Jobs créés
1. **BookingReminderJob** : Envoi de rappels programmés
   - Traitement asynchrone
   - Vérification du statut de réservation
   - Envoi combiné email + SMS

### Contrôleurs modifiés
1. **PaymentsController** : Intégration Stripe
   - Nouvelle action pour Stripe checkout
   - Gestion des retours success/cancel
   - Paiements traditionnels conservés

2. **WebhooksController** : Traitement des événements Stripe
   - Validation des signatures
   - Traitement des événements checkout.session.completed
   - Mise à jour automatique des statuts

### Modèles modifiés
1. **User** : Ajout du champ phone_number
2. **Payment** : Ajout du champ stripe_session_id
3. **Booking** : Méthodes de programmation des rappels

## Configuration requise

### Variables d'environnement
```bash
# Stripe
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Twilio
TWILIO_ACCOUNT_SID=AC...
TWILIO_AUTH_TOKEN=...
TWILIO_PHONE_NUMBER=+1234567890
```

### Credentials Rails (recommandé)
```yaml
stripe:
  publishable_key: pk_test_...
  secret_key: sk_test_...
  webhook_secret: whsec_...

twilio:
  account_sid: AC...
  auth_token: ...
  phone_number: +1234567890
```

## Flux de paiement

### 1. Paiement Stripe
1. Utilisateur clique sur "Payer avec Stripe"
2. Création d'une session Stripe Checkout
3. Redirection vers l'interface Stripe
4. Paiement par l'utilisateur
5. Webhook reçu par l'application
6. Mise à jour du statut de réservation
7. Envoi d'email et SMS de confirmation

### 2. Paiement traditionnel
1. Utilisateur sélectionne un moyen de paiement mobile
2. Enregistrement du paiement avec statut "pending"
3. Confirmation manuelle par l'admin (si nécessaire)
4. Envoi d'email et SMS de confirmation

## Gestion des rappels

### Programmation automatique
- Rappel programmé lors de la confirmation de réservation
- Délai : 24h avant l'heure de réservation
- Vérification : Évite les rappels pour les réservations passées

### Contenu des rappels
- **Email** : Template HTML avec détails complets
- **SMS** : Message court avec informations essentielles

## Tests et débogage

### Stripe
- Utiliser les clés de test pour le développement
- Tester les webhooks avec Stripe CLI
- Vérifier les logs pour les erreurs de paiement

### Twilio
- Utiliser un numéro de test pour le développement
- Vérifier les logs Twilio pour les erreurs d'envoi
- Tester avec des numéros valides

## Sécurité et bonnes pratiques

### Stripe
- Validation obligatoire des webhooks
- Utilisation des métadonnées pour la traçabilité
- Gestion des erreurs et timeouts

### Twilio
- Vérification de la présence du numéro avant envoi
- Gestion des erreurs d'API
- Respect des limites de taux d'envoi

### Données sensibles
- Stockage sécurisé des clés API
- Pas de clés en dur dans le code
- Utilisation des credentials Rails

## Monitoring et maintenance

### Logs à surveiller
- Erreurs de paiement Stripe
- Échecs d'envoi SMS Twilio
- Erreurs de webhook

### Métriques importantes
- Taux de réussite des paiements
- Taux de livraison des SMS
- Temps de traitement des webhooks

## Extensions possibles

### Stripe
- Paiements récurrents pour abonnements
- Remboursements automatiques
- Facturation détaillée

### Twilio
- SMS marketing
- Notifications push
- Appels vocaux automatiques