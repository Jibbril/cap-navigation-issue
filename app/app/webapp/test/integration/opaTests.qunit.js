sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/app/test/integration/FirstJourney',
		'ns/app/test/integration/pages/EntityList',
		'ns/app/test/integration/pages/EntityObjectPage'
    ],
    function(JourneyRunner, opaJourney, EntityList, EntityObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/app') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheEntityList: EntityList,
					onTheEntityObjectPage: EntityObjectPage
                }
            },
            opaJourney.run
        );
    }
);