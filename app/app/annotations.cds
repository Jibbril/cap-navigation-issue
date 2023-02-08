using MyService as service from '../../srv/my-service';

annotate service.Entity with @(
    UI: {
        LineItem: [
            { Value: prop1 }
        ],

        Facets: [
            {
                $Type   : 'UI.CollectionFacet',
                Label   : 'ThirdEntities',
                ID      : 'collectionFacet',
                Facets  : [
                    {
                        $Type   : 'UI.ReferenceFacet',
                        ID      : 'tableFacet',
                        Target  : 'otherEntity/thirdEntities/@UI.LineItem'
                    }
                ]
            },
        ]
    }
);

annotate service.ThirdEntity with @UI.LineItem: [
    { Value: prop1 },
];