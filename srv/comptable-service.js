import cds from '@sap/cds';

const round2 = n => Math.round(n * 100) / 100;

export default class ComptableService extends cds.ApplicationService {
  init() {
    const { Factures } = this.entities;
    const { Factures: DBFactures } = cds.entities('fact');

    // 1. Blocage : facture déjà payée
    this.before(['UPDATE', 'DELETE'], Factures, async (req) => {
      const f = await SELECT.one.from(DBFactures).columns('statut_code').where({ ID: req.data.ID });
      if (f?.statut_code === 'PAYEE') {
        return req.reject(400, 'Facture déjà payée : modification interdite');
      }
    });

    // 2. Refus sans ligne + 3. calcul du total TTC
    this.before('SAVE', Factures, (req) => {
      const { lignes } = req.data;
      if (req.event === 'CREATE' || lignes !== undefined) {
        if (!lignes || lignes.length === 0) {
          return req.reject(400, 'Une facture doit contenir au moins une ligne');
        }
        let ht = 0, ttc = 0;
        for (const l of lignes) {
          const m = (l.quantite || 0) * (l.prixUnitaire || 0);
          ht  += m;
          ttc += m * (1 + (l.tva ?? 18) / 100);
        }
        req.data.totalHT  = round2(ht);
        req.data.totalTTC = round2(ttc);
      }
    });

    return super.init();
  }
}
