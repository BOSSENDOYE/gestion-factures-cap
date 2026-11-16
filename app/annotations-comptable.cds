using ComptableService as comptable from '../srv/comptable-service';

annotate comptable.Factures with @odata.draft.enabled;

annotate comptable.Fournisseurs with @cds.odata.valuelist;

annotate comptable.Fournisseurs with {
  nom   @title: 'Fournisseur';
  email @title: 'Email';
  iban  @title: 'IBAN';
};

annotate comptable.Factures with {
  numero      @title: 'N° facture';
  dateFacture @title: 'Date';
  fournisseur @title: 'Fournisseur'
              @Common.Text: fournisseur.nom
              @Common.TextArrangement: #TextOnly;
  devise      @title: 'Devise';
  statut      @title: 'Statut'
              @Common.Text: statut.name
              @Common.TextArrangement: #TextOnly;
  totalHT     @title: 'Total HT'  @readonly;
  totalTTC    @title: 'Total TTC' @readonly;
  motifRejet  @title: 'Motif de rejet' @readonly;
};

annotate comptable.LignesFacture with {
  designation  @title: 'Désignation';
  quantite     @title: 'Quantité';
  prixUnitaire @title: 'Prix unitaire';
  tva          @title: 'TVA %';
};

annotate comptable.Factures with @(
  UI.HeaderInfo: {
    TypeName: 'Facture',
    TypeNamePlural: 'Factures',
    Title: { Value: numero },
    Description: { Value: fournisseur.nom }
  },
  UI.SelectionFields: [ numero, fournisseur_ID, statut_code, devise_code ],
  UI.LineItem: [
    { Value: numero },
    { Value: fournisseur_ID },
    { Value: dateFacture },
    { Value: totalTTC },
    { Value: devise_code },
    { Value: statut_code }
  ],
  UI.Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'Informations', Target: '@UI.FieldGroup#Infos' },
    { $Type: 'UI.ReferenceFacet', Label: 'Lignes de facture', Target: 'lignes/@UI.LineItem' }
  ],
  UI.FieldGroup #Infos: {
    Data: [
      { Value: numero },
      { Value: dateFacture },
      { Value: fournisseur_ID },
      { Value: devise_code },
      { Value: totalHT },
      { Value: totalTTC },
      { Value: statut_code },
      { Value: motifRejet }
    ]
  }
);

annotate comptable.LignesFacture with @(
  UI.HeaderInfo: { TypeName: 'Ligne', TypeNamePlural: 'Lignes' },
  UI.LineItem: [
    { Value: designation },
    { Value: quantite },
    { Value: prixUnitaire },
    { Value: tva }
  ]
);