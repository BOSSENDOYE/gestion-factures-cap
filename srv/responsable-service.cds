using { fact } from '../db/schema';

service ResponsableService @(path: '/responsable') {
  @readonly entity Fournisseurs  as projection on fact.Fournisseurs;
  @readonly entity LignesFacture as projection on fact.LignesFacture;
  @readonly entity StatutFacture as projection on fact.StatutFacture;
  @readonly entity OrdresPaiement as projection on fact.OrdresPaiement;

  @readonly entity Factures as projection on fact.Factures actions {
    action valider();
    action rejeter(motif : String(255));
  };

  action genererOrdrePaiement(fournisseur_ID : UUID, factures : many UUID) returns OrdresPaiement;
}
