Application Mobile de Météo

## Contexte du projet
Ce projet a été réalisé dans le cadre d'un projet académique. L'objectif était de développer une application mobile permettant d'afficher les prévisions météorologiques détaillées en fonction des coordonnées géographiques de l'utilisateur, ainsi qu'en fonction de la recherche d'une ville spécifique. L'application interagit avec l'API gratuite **Dark Sky** pour récupérer les données météorologiques.

## Technologies utilisées
- **Langage de programmation** : Swift
- **Framework** : SwiftUI
- **API** : Dark Sky API (pour les données météorologiques)
- **Stockage local** : UserDefaults (pour la sauvegarde des villes)

## Fonctionnalités principales
### 1. Page de recherche
L'utilisateur peut rechercher une ville en saisissant son nom dans une barre de recherche. Il est possible d'ajouter des villes à la liste des villes sauvegardées après la recherche.

### 2. Page des informations détaillées sur la météo
Une fois qu'une ville est sélectionnée, l'application affiche les informations suivantes :
- Météo actuelle (température, conditions)
- Prévisions météo sur 5 jours avec détails des températures et conditions pour chaque jour
- Détails supplémentaires comme la vitesse du vent, la pression, l'humidité, etc.
- Les températures sont affichées en Celsius et en Fahrenheit.
- Interface scrollable pour afficher la température selon l'heure de la journée.

### 3. Liste des villes sauvegardées
L'utilisateur peut consulter la liste des villes qu'il a sauvegardées, ainsi que supprimer des villes de cette liste.

## Architecture de l'application
L'application utilise une architecture simple où chaque fonctionnalité est contenue dans des vues distinctes :

- **SearchView** : La page de recherche de villes.
- **WeatherDetailView** : Affiche les détails météorologiques pour une ville sélectionnée.
- **SavedCitiesView** : Affiche les villes sauvegardées par l'utilisateur.
  
Les données météorologiques sont récupérées de l'API Dark Sky en fonction des coordonnées géographiques de l'appareil ou du nom de la ville recherchée.
