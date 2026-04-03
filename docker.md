================================================================================
         DOCKER & DOCKER COMPOSE — TOUTES LES COMMANDES EXPERT
================================================================================

  [clé]    = commande du quotidien, mémoire musculaire
  [expert] = commande avancée, distingue un vrai expert

================================================================================
 1. IMAGES
================================================================================

[clé]    docker build -t nom:tag .                          Construire une image depuis un Dockerfile
[clé]    docker build -f Dockerfile.prod -t nom:tag .       Builder depuis un Dockerfile alternatif
[expert] docker build --target stage -t nom:tag .           Builder un stage spécifique (multi-stage)
[expert] docker build --build-arg VAR=val -t nom:tag .      Passer un argument de build
[expert] docker buildx build --platform linux/amd64,linux/arm64 -t nom:tag --push .
                                                            Build multi-architecture
[expert] docker buildx build --cache-from type=registry,ref=nom:cache --cache-to type=registry,ref=nom:cache -t nom:tag .
                                                            Build avec cache externe (CI/CD)
[clé]    docker images                                      Lister les images locales
         docker images -a                                   Inclure les images intermédiaires
[clé]    docker pull image:tag                              Télécharger une image
[clé]    docker push image:tag                              Pousser une image sur un registry
[clé]    docker tag source:tag dest:tag                     Retagger une image
         docker rmi image                                   Supprimer une image
         docker rmi $(docker images -q)                     Supprimer toutes les images
[clé]    docker image prune -f                              Supprimer les images dangling
         docker image prune -a                              Supprimer toutes les images non utilisées
[expert] docker image inspect nom:tag                       Détails JSON d'une image (layers, env, cmd)
[expert] docker history nom:tag                             Voir chaque layer et sa taille
[expert] docker save nom:tag -o image.tar                   Exporter une image en archive
[expert] docker load -i image.tar                           Importer une image depuis une archive
[expert] docker manifest inspect nom:tag                    Inspecter un manifest multi-plateforme
         docker search mot-clé                              Chercher sur Docker Hub

================================================================================
 2. CONTENEURS — CYCLE DE VIE
================================================================================

[clé]    docker run -d -p 8080:80 --name app image          Lancer en background avec port mapping
[clé]    docker run --rm -it image bash                     Shell éphémère interactif
         docker run -d --restart unless-stopped image       Redémarrage auto sauf arrêt manuel
[expert] docker run --cpus 2 --memory 512m image            Limiter CPU et RAM
[expert] docker run --read-only --tmpfs /tmp image          Filesystem en lecture seule
[expert] docker run --cap-drop ALL --cap-add NET_BIND_SERVICE image
                                                            Principe du moindre privilège (capabilities)
[expert] docker run --security-opt no-new-privileges image  Empêcher l'escalade de privilèges
[expert] docker run --pid host image                        Partager le namespace PID de l'hôte
[expert] docker run --init image                            Injecter tini comme PID 1 (reap zombies)
[expert] docker run -e ENV_VAR=val --env-file .env image    Variables d'environnement
         docker create --name app image                     Créer sans démarrer
[clé]    docker start nom                                   Démarrer un conteneur existant
[clé]    docker stop nom                                    Arrêt gracieux (SIGTERM puis SIGKILL après 10s)
         docker stop -t 30 nom                              Arrêt gracieux avec timeout custom (30s)
[clé]    docker restart nom                                 Redémarrer
         docker kill nom                                    Envoyer SIGKILL immédiatement
[expert] docker kill -s SIGUSR1 nom                         Envoyer un signal custom
         docker pause nom                                   Geler un conteneur (cgroups freezer)
         docker unpause nom                                 Reprendre un conteneur gelé
[clé]    docker rm nom                                      Supprimer un conteneur stoppé
         docker rm -f nom                                   Forcer la suppression (même en cours)
         docker rm $(docker ps -aq)                         Supprimer tous les conteneurs stoppés
[expert] docker rename ancien nouveau                       Renommer un conteneur
[expert] docker update --memory 1g --cpus 4 nom             Modifier les limites à chaud
[expert] docker wait nom                                    Bloquer jusqu'à l'arrêt et afficher l'exit code
[expert] docker commit nom nouvelle-image:tag               Créer une image depuis l'état d'un conteneur
[expert] docker export nom -o conteneur.tar                 Exporter le filesystem d'un conteneur
[expert] docker import conteneur.tar nom:tag                Importer un filesystem comme image

================================================================================
 3. INSPECTION & DEBUG
================================================================================

[clé]    docker ps                                          Lister les conteneurs en cours
[clé]    docker ps -a                                       Lister tous les conteneurs (y compris stoppés)
         docker ps -q                                       IDs uniquement (pour scripting)
         docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
                                                            Format custom
[clé]    docker logs nom                                    Voir les logs
[clé]    docker logs -f nom                                 Suivre les logs en temps réel
         docker logs --tail 100 nom                         Dernières 100 lignes
         docker logs --since 1h nom                         Logs de la dernière heure
         docker logs -t nom                                 Logs avec timestamps
[clé]    docker exec -it nom bash                           Shell dans un conteneur en cours
         docker exec -it nom sh                             Shell POSIX (images Alpine)
         docker exec -u root nom cmd                        Exécuter en tant que root
         docker exec -e VAR=val nom cmd                     Avec variable d'environnement
[clé]    docker inspect nom                                 Dump JSON complet (réseau, volumes, env…)
[expert] docker inspect -f '{{.State.Pid}}' nom             Extraire le PID du process principal
[expert] docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nom
                                                            Extraire l'IP d'un conteneur
[expert] docker inspect -f '{{json .Config.Env}}' nom | jq Extraire les variables d'env avec jq
[clé]    docker stats                                       Monitoring CPU/RAM en temps réel
         docker stats --no-stream                           Snapshot unique (pour scripts)
         docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
                                                            Format custom
[clé]    docker top nom                                     Processus actifs dans un conteneur
[expert] docker diff nom                                    Fichiers modifiés/ajoutés/supprimés dans le conteneur
[expert] docker port nom                                    Voir les ports mappés
[expert] docker cp nom:/chemin/fichier ./local              Copier un fichier hors d'un conteneur
[expert] docker cp ./local nom:/chemin/fichier              Copier un fichier dans un conteneur
[expert] docker attach nom                                  S'attacher au STDIN/STDOUT du process principal
                                                            (Ctrl+P Ctrl+Q pour détacher sans tuer)

================================================================================
 4. RÉSEAU
================================================================================

[clé]    docker network ls                                  Lister tous les réseaux
[clé]    docker network create monreseau                    Créer un réseau bridge custom
[expert] docker network create --driver overlay monreseau   Réseau overlay (Swarm / multi-host)
[expert] docker network create --subnet 172.20.0.0/16 monreseau
                                                            Réseau avec subnet custom
[clé]    docker network inspect monreseau                   Voir les conteneurs attachés et la config
[expert] docker network connect monreseau nom               Attacher un conteneur à un réseau supplémentaire
[expert] docker network disconnect monreseau nom            Détacher un conteneur d'un réseau
         docker network rm monreseau                        Supprimer un réseau
         docker network prune                               Supprimer les réseaux non utilisés
[expert] docker run --network host image                    Partager le réseau de l'hôte (Linux uniquement)
[expert] docker run --network none image                    Isolation réseau totale
[expert] docker run --dns 8.8.8.8 image                    Forcer un DNS custom

================================================================================
 5. VOLUMES & STOCKAGE
================================================================================

         docker volume ls                                   Lister les volumes
[clé]    docker volume create monvol                        Créer un named volume
[clé]    docker volume inspect monvol                       Voir le mountpoint et les options
         docker volume rm monvol                            Supprimer un volume
[expert] docker volume prune                                Supprimer les volumes orphelins
[expert] docker run -v monvol:/data image tar czf /backup.tar.gz /data
                                                            Backup d'un volume via conteneur temp
[expert] docker run --volumes-from autre image              Partager les volumes d'un autre conteneur
[expert] docker run --tmpfs /tmp:rw,noexec,size=100m image  Monter un tmpfs avec options
[clé]    docker run -v $(pwd):/app image                    Bind mount du répertoire courant
[expert] docker run -v $(pwd):/app:ro image                 Bind mount en lecture seule

================================================================================
 6. REGISTRY & AUTHENTIFICATION
================================================================================

[clé]    docker login registry.example.com                  S'authentifier sur un registry
         docker logout registry.example.com                 Se déconnecter
[clé]    docker push nom:tag                                Pousser une image
         docker pull nom:tag                                Télécharger une image
         docker search mot-clé                              Chercher sur Docker Hub
[expert] docker trust sign nom:tag                          Signer une image (Docker Content Trust)
[expert] DOCKER_CONTENT_TRUST=1 docker pull nom:tag         Forcer la vérification de signature

================================================================================
 7. SYSTÈME & NETTOYAGE
================================================================================

[clé]    docker system df                                   Espace disque utilisé par Docker
[clé]    docker system prune                                Purge : conteneurs/images/réseaux inutilisés
[expert] docker system prune -a --volumes                   Purge totale incluant volumes et toutes images
[expert] docker system info                                 Config daemon, storage driver, cgroups
[expert] docker system events                               Flux d'événements Docker en temps réel
[expert] docker system events --filter type=container       Filtrer les événements par type
         docker info                                        Résumé système
         docker version                                     Version client et daemon
[clé]    docker builder prune -af                           Vider le cache de build
[expert] nsenter -t $(docker inspect -f '{{.State.Pid}}' nom) -n
                                                            Entrer dans le namespace réseau d'un conteneur

================================================================================
 8. COMPOSE — BASE
================================================================================

[clé]    docker compose up -d                               Démarrer tous les services en background
[clé]    docker compose up -d --build                       Rebuild les images avant de démarrer
[clé]    docker compose up -d --force-recreate              Recréer les conteneurs même sans changement
[clé]    docker compose up -d --remove-orphans              Supprimer les services supprimés du fichier
         docker compose up -d service1 service2             Démarrer seulement certains services
[clé]    docker compose down                                Stopper et supprimer conteneurs + réseaux
[clé]    docker compose down -v                             Idem + supprimer les volumes
[expert] docker compose down --rmi all                      Idem + supprimer les images buildées
         docker compose start / stop / restart              Cycle de vie sans recréer les conteneurs
[expert] docker compose pause / unpause                     Geler / reprendre les services
         docker compose pull                                Télécharger les dernières images
[clé]    docker compose build                               Builder toutes les images sans démarrer
         docker compose build --no-cache service            Rebuild complet d'un service
[expert] docker compose build --parallel                    Builder tous les services en parallèle

================================================================================
 9. COMPOSE — LOGS & DEBUG
================================================================================

[clé]    docker compose logs -f                             Suivre les logs de tous les services
[clé]    docker compose logs -f service                     Logs d'un service spécifique
         docker compose logs --tail 50 service              Dernières 50 lignes d'un service
         docker compose logs -t service                     Logs avec timestamps
[clé]    docker compose exec service bash                   Shell dans un service en cours
[clé]    docker compose run --rm service cmd                Lancer une commande one-shot
[expert] docker compose run --rm --no-deps service cmd      One-shot sans démarrer les dépendances
[clé]    docker compose ps                                  État des services
         docker compose ps -a                               Inclure les services stoppés
[expert] docker compose top                                 Processus de tous les services

================================================================================
 10. COMPOSE — INSPECTION & CONFIG
================================================================================

[expert] docker compose config                              Afficher la config résolue (variables, merge)
[expert] docker compose config --services                   Lister les noms de services
[expert] docker compose config --volumes                    Lister les volumes déclarés
[expert] docker compose config --profiles                   Lister les profils disponibles
[expert] docker compose images                              Images utilisées par les services
[expert] docker compose port service 80                     Port hôte mappé pour un port interne

================================================================================
 11. COMPOSE — AVANCÉ
================================================================================

[expert] docker compose -f base.yml -f override.yml up -d   Merge de fichiers Compose
[expert] docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
                                                            Override par environnement
[expert] docker compose --profile debug up -d               Activer un profil de services
[expert] docker compose --env-file .env.prod up -d          Utiliser un fichier d'env spécifique
[expert] docker compose up -d --scale service=3             Scaler un service à N réplicas
[expert] docker compose cp service:/chemin ./local          Copier depuis un service
[expert] docker compose alpha watch                         Hot reload automatique (dev loop)
[expert] docker compose convert                             Convertir en format canonique
[expert] docker compose create                              Créer les conteneurs sans les démarrer
[expert] docker compose events                              Stream d'événements des services
[expert] docker compose wait service                        Attendre qu'un service soit healthy

================================================================================
 12. DOCKERFILE — INSTRUCTIONS ESSENTIELLES
================================================================================

FROM image:tag                          Image de base
FROM image:tag AS builder               Stage nommé (multi-stage)
RUN commande                            Exécuter une commande (crée un layer)
RUN --mount=type=cache,target=/root/.cache commande
                                        Monter un cache persistant entre builds
RUN --mount=type=secret,id=mysecret     Utiliser un secret sans le stocker dans l'image
COPY src dest                           Copier des fichiers depuis le contexte
COPY --from=builder /app/bin /usr/bin/  Copier depuis un stage précédent
ADD archive.tar.gz /dest                Copier + décompresser (préférer COPY sinon)
WORKDIR /app                            Répertoire de travail
ENV VAR=val                             Variable d'environnement persistée dans l'image
ARG VAR=val                             Variable disponible uniquement au build
EXPOSE 8080                             Documenter le port (pas de publication auto)
ENTRYPOINT ["executable"]               Point d'entrée (ne peut pas être remplacé facilement)
CMD ["arg1", "arg2"]                    Arguments par défaut (remplaçable au run)
USER nonroot                            Changer d'utilisateur
HEALTHCHECK --interval=30s CMD curl -f http://localhost/ || exit 1
                                        Vérification de santé
LABEL maintainer="nom"                  Métadonnée
VOLUME /data                            Déclarer un volume anonyme
STOPSIGNAL SIGTERM                      Signal d'arrêt
SHELL ["/bin/bash", "-c"]               Shell par défaut pour RUN

================================================================================
 13. COMPOSE YAML — DIRECTIVES CLÉS
================================================================================

services:
  app:
    image: nom:tag                      Image à utiliser
    build:
      context: .                        Contexte de build
      dockerfile: Dockerfile.prod       Dockerfile alternatif
      target: production                Stage cible (multi-stage)
      args:
        - VAR=val                       Build args
    ports:
      - "8080:80"                       Port mapping host:conteneur
    volumes:
      - ./src:/app/src                  Bind mount
      - data:/app/data                  Named volume
    environment:
      - VAR=val                         Variable inline
    env_file:
      - .env                            Fichier de variables
    depends_on:
      db:
        condition: service_healthy      Attendre que db soit healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    restart: unless-stopped             Politique de redémarrage
    networks:
      - frontend
      - backend
    deploy:
      resources:
        limits:
          cpus: "2"
          memory: 512M
    profiles:
      - debug                           Actif seulement avec --profile debug
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    command: ["./start.sh"]             Override du CMD
    entrypoint: ["/entrypoint.sh"]      Override de l'ENTRYPOINT
    working_dir: /app
    user: "1000:1000"
    read_only: true
    tmpfs:
      - /tmp
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
    security_opt:
      - no-new-privileges:true

volumes:
  data:
    driver: local

networks:
  frontend:
  backend:
    internal: true                      Pas d'accès Internet

================================================================================
 14. TIPS PRO
================================================================================

• docker inspect + jq = parsing JSON surpuissant
  docker inspect nom | jq '.[0].NetworkSettings.Networks'

• Alias shell recommandés :
  alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
  alias dlogs="docker compose logs -f"
  alias dexec="docker compose exec"
  alias dnuke="docker system prune -af --volumes && docker builder prune -af"

• Script nuke complet (wipe total) :
  docker compose down -v --rmi all --remove-orphans
  docker system prune -af --volumes
  docker builder prune -af

• Déboguer une image sans shell :
  docker run --rm -it --entrypoint sh image

• Voir pourquoi un conteneur a crashé :
  docker inspect -f '{{.State.ExitCode}} {{.State.Error}}' nom

• Suivre les événements en temps réel pendant un debug :
  docker system events --filter type=container --format '{{.Action}} {{.Actor.Attributes.name}}'

================================================================================
 TOTAL : ~150 commandes, flags et directives
 Maîtrise tout ça et tu seras un expert Docker/Compose absolu.
================================================================================
