using { fact } from '../db/schema';

service ComptableService @(path: '/comptable') {
  entity Fournisseurs  as projection on fact.Fournisseurs;
  entity Factures      as projection on fact.Factures;
  entity LignesFacture as projection on fact.LignesFacture;
  entity StatutFacture as projection on fact.StatutFacture;
}
