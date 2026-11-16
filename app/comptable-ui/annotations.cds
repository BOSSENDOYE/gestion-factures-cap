using AnalyseService as service from '../../srv/analyse-service';
annotate service.AnalyseFactures with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : fournisseurNom,
            },
            {
                $Type : 'UI.DataField',
                Value : statutNom,
            },
            {
                $Type : 'UI.DataField',
                Value : totalTTC,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
);

