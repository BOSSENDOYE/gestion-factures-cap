#!/bin/bash
H='Content-Type: application/json'
B=localhost:4004
F=11111111-1111-1111-1111-111111111111
L='"lignes":[{"designation":"Forfait","quantite":10,"prixUnitaire":100,"tva":18}]'

mk() {
  curl -s -X POST $B/comptable/Factures -H "$H" \
    -d "{\"numero\":\"$1\",\"fournisseur_ID\":\"$F\",\"devise_code\":\"XOF\",$L}" \
    | grep -o '"ID":"[^"]*"' | head -1 | cut -d'"' -f4
}

ID1=$(mk F-101)
ID2=$(mk F-102)
echo "IDs: $ID1 $ID2"

echo; echo "== 1. valider F-101 (OK attendu, pas de contenu)"
curl -s -i -X POST "$B/responsable/Factures($ID1)/ResponsableService.valider" -H "$H" -d '{}' | head -1

echo; echo "== 2. rejeter F-102 sans motif (400 attendu)"
curl -s -X POST "$B/responsable/Factures($ID2)/ResponsableService.rejeter" -H "$H" -d '{"motif":""}'

echo; echo; echo "== 3. ordre avec F-102 non validée (400 attendu)"
curl -s -X POST $B/responsable/genererOrdrePaiement -H "$H" \
  -d "{\"fournisseur_ID\":\"$F\",\"factures\":[\"$ID1\",\"$ID2\"]}"

echo; echo; echo "== 4. valider F-102"
curl -s -i -X POST "$B/responsable/Factures($ID2)/ResponsableService.valider" -H "$H" -d '{}' | head -1

echo; echo "== 5. ordre avec les 2 validées (total 2360 attendu)"
curl -s -X POST $B/responsable/genererOrdrePaiement -H "$H" \
  -d "{\"fournisseur_ID\":\"$F\",\"factures\":[\"$ID1\",\"$ID2\"]}"
echo
