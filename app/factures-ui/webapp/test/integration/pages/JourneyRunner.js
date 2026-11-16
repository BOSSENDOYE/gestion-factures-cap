sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"facturesui/test/integration/pages/FacturesList.gen",
	"facturesui/test/integration/pages/FacturesObjectPage.gen",
	"facturesui/test/integration/pages/LignesFactureObjectPage.gen"
], function (JourneyRunner, FacturesListGenerated, FacturesObjectPageGenerated, LignesFactureObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('facturesui') + '/test/flp.html#app-preview',
        pages: {
			onTheFacturesListGenerated: FacturesListGenerated,
			onTheFacturesObjectPageGenerated: FacturesObjectPageGenerated,
			onTheLignesFactureObjectPageGenerated: LignesFactureObjectPageGenerated
        },
        async: true
    });

    return runner;
});

