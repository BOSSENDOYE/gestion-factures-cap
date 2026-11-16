using ResponsableService as responsable from '../srv/responsable-service';

annotate responsable.Fournisseurs with @cds.odata.valuelist;

annotate responsable.Factures with {
  fournisseur @Common.Text: fournisseur.nom @Common.TextArrangement: #TextOnly;
  statut      @Common.Text: statut.name     @Common.TextArrangement: #TextOnly;
};

annotate responsable.Factures with @(
  UI.HeaderInfo: {
    TypeName: 'Facture',
    TypeNamePlural: 'Factures à traiter',
    Title: { Value: numero },
    Description: { Value: fournisseur.nom }
  },
  UI.SelectionFields: [ numero, fournisseur_ID, statut_code ],
  UI.LineItem: [
    { Value: numero },
    { Value: fournisseur_ID },
    { Value: dateFacture },
    { Value: totalTTC },
    { Value: statut_code },
    { $Type: 'UI.DataFieldForAction', Action: 'ResponsableService.valider', Label: 'Valider' },
    { $Type: 'UI.DataFieldForAction', Action: 'ResponsableService.rejeter', Label: 'Rejeter' }
  ],
  UI.Identification: [
    { $Type: 'UI.DataFieldForAction', Action: 'ResponsableService.valider', Label: 'Valider' },
    { $Type: 'UI.DataFieldForAction', Action: 'ResponsableService.rejeter', Label: 'Rejeter' }
  ],
  UI.Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'Informations', Target: '@UI.FieldGroup#Infos' }
  ],
  UI.FieldGroup #Infos: {
    Data: [
      { Value: numero },
      { Value: fournisseur_ID },
      { Value: totalHT },
      { Value: totalTTC },
      { Value: statut_code },
      { Value: motifRejet }
    ]
  }
);