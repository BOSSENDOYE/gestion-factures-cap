using ComptableService   from './comptable-service';
using ResponsableService from './responsable-service';
using AnalyseService     from './analyse-service';

// Un rôle par service
annotate ComptableService   with @(requires: 'comptable');
annotate ResponsableService with @(requires: 'responsable');
annotate AnalyseService     with @(requires: ['comptable', 'responsable']);

// Droits fins sur les factures
annotate ComptableService.Factures with @(restrict: [
  { grant: '*', to: 'comptable' }
]);

annotate ResponsableService.Factures with @(restrict: [
  { grant: ['READ', 'valider', 'rejeter'], to: 'responsable' }
]);