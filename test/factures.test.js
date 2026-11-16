import cds from '@sap/cds';

const F1 = 'aaaaaaaa-0000-0000-0000-000000000001';
const F2 = 'aaaaaaaa-0000-0000-0000-000000000002';
const S1 = '11111111-1111-1111-1111-111111111111';

const as = u => ({ auth: { username: u, password: u } });
const code = p => p.then(r => r.status, e => e.response?.status);

describe('Sécurité et actions', () => {
  const { GET, POST } = cds.test(process.cwd());

  test('anonyme refusé (401)', async () => {
    expect(await code(GET('/comptable/Factures'))).toBe(401);
  });

  test('comptable peut lire ses factures', async () => {
    const r = await GET('/comptable/Factures', as('comptable'));
    expect(r.status).toBe(200);
    expect(r.data.value.length).toBe(2);
  });

  test('responsable ne peut pas saisir (403)', async () => {
    const s = await code(POST('/comptable/Factures', {}, as('responsable')));
    expect(s).toBe(403);
  });

  test('comptable ne peut pas valider (403)', async () => {
    const s = await code(POST(`/responsable/Factures(${F1})/ResponsableService.valider`, {}, as('comptable')));
    expect(s).toBe(403);
  });

  test('rejeter sans motif refusé (400)', async () => {
    const s = await code(POST(`/responsable/Factures(${F2})/ResponsableService.rejeter`, { motif: '' }, as('responsable')));
    expect(s).toBe(400);
  });

  test('responsable peut valider (204)', async () => {
    const s = await code(POST(`/responsable/Factures(${F1})/ResponsableService.valider`, {}, as('responsable')));
    expect(s).toBe(204);
  });

  test('valider deux fois refusé (409)', async () => {
    const s = await code(POST(`/responsable/Factures(${F1})/ResponsableService.valider`, {}, as('responsable')));
    expect(s).toBe(409);
  });

  test('ordre de paiement refusé si fournisseurs différents (400)', async () => {
    const s = await code(POST('/responsable/genererOrdrePaiement',
      { fournisseur_ID: S1, factures: [F1, F2] }, as('responsable')));
    expect(s).toBe(400);
  });
});