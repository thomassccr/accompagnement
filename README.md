# Site d'accompagnement

Landing page de l'accompagnement individuel en trading, avec formulaire de candidature.
Site statique : aucun serveur à gérer, aucune dépendance à installer.

```
index.html            la page principale
cgv.html              conditions générales de vente
confidentialite.html  politique de confidentialité
img/                  les photos (voir img/README.md)
supabase-schema.sql   à exécuter une fois pour recevoir les candidatures
```

---

## 1. Mettre le site en ligne

**Vercel** (recommandé, fonctionne avec un dépôt privé)
[vercel.com/new](https://vercel.com/new) → importe ce dépôt → *Deploy*. Rien à configurer :
Vercel détecte un site statique. Chaque commit redéploie automatiquement.

**GitHub Pages** (gratuit, nécessite un dépôt public)
Settings → Pages → Source : `main`, dossier `/ (root)` → Save.
Le site sort sur `https://<utilisateur>.github.io/accompagnement/`.

## 2. Recevoir les candidatures

1. [supabase.com](https://supabase.com) → ton projet → **SQL Editor**
2. Colle le contenu de `supabase-schema.sql` → **Run**
3. Les candidatures arrivent dans **Table Editor → `formation_candidatures`**

Sécurité : le site ne peut qu'**ajouter** une candidature, jamais en lire. Personne ne peut
récupérer tes candidatures depuis un navigateur. Tu les consultes depuis Supabase.

Dans `index.html`, bloc `CONFIG` en bas de fichier, remplace `contact@exemple.com` par ton
adresse email : elle sert de secours si Supabase est injoignable.

Pour être prévenu par email à chaque candidature : Supabase → *Database → Webhooks*, sur
`INSERT` de la table, vers Zapier, Make ou Resend.

## 3. Personnaliser le contenu

Tout ce qui reste à adapter est signalé dans `index.html` par un commentaire `[À REMPLIR]`,
et dans les pages légales par un champ surligné `[ENTRE CROCHETS]`.

Points à traiter avant de vendre :

- **Les tarifs** — actuellement « Sur devis » dans les trois formats.
- **Les CGV** — c'est une trame, pas un contrat prêt à l'emploi. Un encadré en haut de
  `cgv.html` liste les trois points à régler (statut juridique, capacité à contracter,
  qualification de l'offre). À faire relire par un professionnel du droit, puis supprimer
  l'encadré.
- **La politique de confidentialité** — renseigner l'identité du responsable de traitement
  et l'hébergeur retenu.

## 4. Ce qui est déjà en place

- Section « Les preuves » : certificats, ticket de trade, poste de travail, agrandissement au clic.
- Témoignages validés par les personnes citées.
- Formulaire de candidature : validation champ par champ, piège anti-robots, écran de
  confirmation, repli par email si la base est injoignable.
- Avertissement sur le risque de perte en capital, et mention du caractère pédagogique de la
  prestation — c'est ce qui distingue une formation d'une activité réglementée.
- Responsive, sans dépendance externe hormis les polices Google.

## Développement local

```bash
python3 -m http.server 8000
# puis http://localhost:8000
```
