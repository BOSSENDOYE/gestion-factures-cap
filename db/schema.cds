using { cuid, managed, sap.common.CodeList, Currency } from '@sap/cds/common';
namespace fact;

entity Fournisseurs : cuid, managed {
  nom      : String(100) @mandatory;
  email    : String(100);
  iban     : String(34);
  factures : Association to many Factures on factures.fournisseur = $self;
}

entity Factures : cuid, managed {
  numero      : String(20) @mandatory;
  dateFacture : Date;
  fournisseur : Association to Fournisseurs;
  statut      : Association to StatutFacture default 'SAISIE';
  devise      : Currency;
  totalHT     : Decimal(15,2);
  totalTTC    : Decimal(15,2);
  motifRejet  : String(255);
  lignes      : Composition of many LignesFacture on lignes.facture = $self;
  ordre       : Association to OrdresPaiement;
}

entity LignesFacture : cuid {
  facture      : Association to Factures;
  designation  : String(200);
  quantite     : Decimal(10,2);
  prixUnitaire : Decimal(15,2);
  tva          : Decimal(5,2) default 18;
}

entity OrdresPaiement : cuid, managed {
  fournisseur : Association to Fournisseurs;
  statut      : Association to StatutOrdre default 'CREE';
  total       : Decimal(15,2);
  factures    : Association to many Factures on factures.ordre = $self;
}

entity StatutFacture : CodeList { key code : String(10); }
entity StatutOrdre   : CodeList { key code : String(10); }
