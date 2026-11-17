# Getting Started

Welcome to your new CAP project.

It contains these folders and files, following our recommended project layout:

File or Folder | Purpose
---------|----------
`app/` | content for UI frontends goes here
`db/` | your domain models and data go here
`srv/` | your service models and code go here
`readme.md` | this getting started guide

## Next Steps

- Open a new terminal and run `cds watch`
- (in VS Code simply choose _**Terminal** > Run Task > cds watch_)
- Start with your domain model, in a CDS file in `db/`

## Learn More

Learn more at <https://cap.cloud.sap>.

## Contenu du projet
- `db/` : modèle de données (Fournisseurs, Factures, Lignes, Ordres de paiement)
- `srv/` : services Comptable, Responsable et Analyse, handlers, sécurité
- `app/` : applications Fiori Elements (saisie, validation, analyse)
- `test/` : tests automatiques `cds.test`
- `mta.yaml` : déploiement SAP BTP (HANA Cloud, XSUAA, HTML5 repository)

## Commandes
- Lancer en local : `npm install` puis `cds watch`
- Tests : `npm test`
- Déployer : `mbt build -t gen --mtar mta.mtar` puis `cf deploy gen/mta.mtar`
