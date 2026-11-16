sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"comptableui/test/integration/pages/AnalyseFacturesList.gen",
	"comptableui/test/integration/pages/AnalyseFacturesObjectPage.gen"
], function (JourneyRunner, AnalyseFacturesListGenerated, AnalyseFacturesObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('comptableui') + '/test/flp.html#app-preview',
        pages: {
			onTheAnalyseFacturesListGenerated: AnalyseFacturesListGenerated,
			onTheAnalyseFacturesObjectPageGenerated: AnalyseFacturesObjectPageGenerated
        },
        async: true
    });

    return runner;
});

