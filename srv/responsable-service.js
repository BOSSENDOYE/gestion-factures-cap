import cds from '@sap/cds';

export default class ResponsableService extends cds.ApplicationService {
  init() {
    const { Factures } = this.entities;
    const db = cds.entities('fact');
    const getId = req => req.params[0]?.ID ?? req.params[0];

    // valider : SAISIE -> VALIDEE
    this.on('valider', Factures, async (req) => {
      const ID = getId(req);
      const f = await SELECT.one.from(db.Factures).where({ ID });
      if (!f) return req.reject(404, 'Facture introuvable');
      if (f.statut_code !== 'SAISIE')
        return req.reject(409, `Validation impossible : statut ${f.statut_code}`);
      await UPDATE(db.Factures).set({ statut_code: 'VALIDEE' }).where({ ID });
    });

    // rejeter : SAISIE -> REJETEE, motif obligatoire
    this.on('rejeter', Factures, async (req) => {
      const ID = getId(req);
      const { motif } = req.data;
      if (!motif?.trim()) return req.reject(400, 'Le motif de rejet est obligatoire');
      const f = await SELECT.one.from(db.Factures).where({ ID });
      if (!f) return req.reject(404, 'Facture introuvable');
      if (f.statut_code !== 'SAISIE')
        return req.reject(409, `Rejet impossible : statut ${f.statut_code}`);
      await UPDATE(db.Factures).set({ statut_code: 'REJETEE', motifRejet: motif }).where({ ID });
    });

    // genererOrdrePaiement : regroupe des factures VALIDEES d'un même fournisseur
    this.on('genererOrdrePaiement', async (req) => {
      const { fournisseur_ID, factures } = req.data;
      if (!factures?.length) return req.reject(400, 'Aucune facture sélectionnée');

      const rows = await SELECT.from(db.Factures).where({ ID: { in: factures } });
      if (rows.length !== factures.length)
        return req.reject(404, 'Une ou plusieurs factures sont introuvables');
      if (rows.some(f => f.fournisseur_ID !== fournisseur_ID))
        return req.reject(400, 'Toutes les factures doivent appartenir au même fournisseur');
      if (rows.some(f => f.statut_code !== 'VALIDEE'))
        return req.reject(400, 'Seules les factures validées peuvent être regroupées');
      if (rows.some(f => f.ordre_ID))
        return req.reject(400, 'Une facture est déjà dans un ordre de paiement');

      const total = Math.round(rows.reduce((s, f) => s + Number(f.totalTTC), 0) * 100) / 100;
      const id = cds.utils.uuid();

      await INSERT.into(db.OrdresPaiement).entries({ ID: id, fournisseur_ID, total, statut_code: 'CREE' });
      await UPDATE(db.Factures).set({ ordre_ID: id }).where({ ID: { in: factures } });

      return SELECT.one.from(db.OrdresPaiement).where({ ID: id });
    });

    return super.init();
  }
}
