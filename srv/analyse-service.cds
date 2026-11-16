using { fact } from '../db/schema';

service AnalyseService @(path: '/analyse') {
  @readonly entity AnalyseFactures as select from fact.Factures {
    key ID,
    fournisseur.nom as fournisseurNom : String,
    statut.name     as statutNom      : String,
    totalTTC
  };
}