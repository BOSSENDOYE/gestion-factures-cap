using AnalyseService as analyse from '../srv/analyse-service';

annotate analyse.AnalyseFactures with {
  fournisseurNom @title: 'Fournisseur';
  statutNom      @title: 'Statut';
  totalTTC       @title: 'Montant TTC'
                 @Analytics.Measure
                 @Aggregation.default: #SUM;
};

annotate analyse.AnalyseFactures with @(
  Aggregation.ApplySupported: {
    Transformations: ['aggregate','topcount','bottomcount','identity','concat','groupby','filter','expand','search','orderby'],
    GroupableProperties: [ fournisseurNom, statutNom ],
    AggregatableProperties: [ { Property: totalTTC } ],
    PropertyRestrictions: true
  },
  Aggregation.CustomAggregate #totalTTC: 'Edm.Decimal',

  UI.HeaderInfo: {
    TypeName: 'Analyse',
    TypeNamePlural: 'Analyse des montants'
  },
  UI.SelectionFields: [ fournisseurNom, statutNom ],

  UI.Chart: {
    Title: 'Montants par fournisseur et par statut',
    ChartType: #ColumnStacked,
    Dimensions: [ fournisseurNom, statutNom ],
    DimensionAttributes: [
      { Dimension: fournisseurNom, Role: #Category },
      { Dimension: statutNom,      Role: #Series }
    ],
    Measures: [ totalTTC ],
    MeasureAttributes: [ { Measure: totalTTC, Role: #Axis1 } ]
  },

  UI.LineItem: [
    { Value: fournisseurNom },
    { Value: statutNom },
    { Value: totalTTC }
  ],

  UI.PresentationVariant: {
    Visualizations: [ '@UI.Chart', '@UI.LineItem' ]
  }
);