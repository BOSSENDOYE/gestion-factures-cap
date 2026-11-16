sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"responsableui/test/integration/pages/FournisseursList.gen",
	"responsableui/test/integration/pages/FournisseursObjectPage.gen"
], function (JourneyRunner, FournisseursListGenerated, FournisseursObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('responsableui') + '/test/flp.html#app-preview',
        pages: {
			onTheFournisseursListGenerated: FournisseursListGenerated,
			onTheFournisseursObjectPageGenerated: FournisseursObjectPageGenerated
        },
        async: true
    });

    return runner;
});

