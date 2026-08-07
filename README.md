# Site d'accompagnement

Landing page de l'accompagnement individuel en trading, avec formulaire de candidature.
Site statique : aucun serveur à gérer, aucune dépendance à installer.

```
index.html            la page principale
cgv.html              conditions générales de vente
confidentialite.html  politique de confidentialité
avertissement.html    avertissement sur les risques et les résultats
img/                  les photos (voir img/README.md)
img/questionnaire/    une photo par question du formulaire (voir son README)
media/                les vidéos (voir media/README.md)
supabase-schema.sql   à exécuter une fois pour recevoir les candidatures
```

---

## 1. Mettre le site en ligne

**Vercel** (recommandé, fonctionne avec un dépôt privé)
[vercel.com/new](https://vercel.com/new) → importe ce dépôt → *Deploy*. Rien à configurer :
Vercel détecte un site statique. Chaque commit redéploie automatiquement.

Adresse du site : **https://4edge.vercel.app**

Pour la changer : projet Vercel → onglet **Domains** → *Add*. Renommer le projet
ne change pas l'adresse, ce sont deux réglages distincts. Après un changement,
mets à jour dans `index.html` les balises `canonical`, `og:url`, `og:image` et
`twitter:image` — elles contiennent l'adresse en dur, c'est ce qui permet à
WhatsApp, Instagram ou Discord d'afficher un aperçu quand tu partages le lien.

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

### Envoyer le candidat sur une autre page après le questionnaire

Dans `index.html`, bloc `CONFIG` en bas de fichier :

```js
REDIRECT_URL:   'https://exemple.com/merci',   // la page d'arrivée
REDIRECT_DELAI: 2                              // secondes avant le départ
```

Laisse `REDIRECT_URL` vide pour que le candidat reste sur l'écran de confirmation
du site, comme aujourd'hui. Mets `REDIRECT_DELAI` à `0` pour partir immédiatement.

Deux garde-fous, volontaires :

- **La redirection ne part que si la candidature a bien été enregistrée.** Si
  Supabase est injoignable, le candidat reste sur la page et reçoit le lien de
  repli par email. Sans ça, une panne de base t'aurait fait perdre la
  candidature *et* le candidat.
- **Un bouton « Continuer » s'affiche pendant l'attente**, au cas où le
  navigateur bloque le départ automatique.

L'adresse doit être complète, avec `https://`. Une adresse sans protocole
(`exemple.com/merci`) serait interprétée comme un dossier de ton propre site.

### Recevoir un email à chaque candidature

Supabase enregistre, mais ne prévient pas. Pour être alerté, on branche un webhook sur
l'ajout d'une ligne, et un service qui met en forme l'email. Compte 10 minutes, sans code.

**A. Créer le point d'arrivée (make.com, gratuit)**

1. Crée un compte sur [make.com](https://www.make.com) → *Create a new scenario*
2. Clique le gros `+` → cherche **Webhooks** → choisis **Custom webhook** → *Add* →
   nomme-le `candidature` → *Save* → **copie l'URL** affichée
3. Clique le `+` à droite du webhook → cherche **Email** → **Send me an email**
4. Remplis :
   - *To* : ton adresse
   - *Subject* : `Nouvelle candidature`
   - *Content* : tape ton texte et insère les champs depuis le panneau de droite,
     ils apparaissent sous `record` (`record.prenom`, `record.email`, `record.experience`…)
5. En bas à gauche, bascule l'interrupteur du scénario sur **ON**

**B. Brancher Supabase dessus**

1. Supabase → menu de gauche → **Database** → **Webhooks** → *Enable webhooks* si demandé
2. *Create a new hook* :
   - *Name* : `nouvelle_candidature`
   - *Table* : `formation_candidatures`
   - *Events* : coche **Insert** uniquement
   - *Type* : **HTTP Request**, méthode **POST**
   - *URL* : colle l'URL copiée à l'étape A2
3. *Create webhook*

**Contenu de l'email (Body type : Raw HTML)**

Le `1.` correspond au numéro du module webhook dans le scénario. Vérifie-le : si ton
webhook porte un autre numéro, remplace-le partout.

```html
<div style="font-family:-apple-system,Segoe UI,sans-serif;font-size:15px;color:#222;">
  <h2 style="margin:0 0 4px;">{{1.record.prenom}} {{1.record.nom}}</h2>
  <p style="margin:0 0 18px;color:#666;">
    {{1.record.age}} &middot; {{1.record.situation}}<br>
    <a href="mailto:{{1.record.email}}">{{1.record.email}}</a><br>
    {{1.record.telephone}} &nbsp; {{1.record.reseau}}
  </p>

  <table cellpadding="7" style="border-collapse:collapse;font-size:14px;">
    <tr><td style="color:#888;">Niveau</td><td><b>{{1.record.experience}}</b></td></tr>
    <tr><td style="color:#888;">Marchés</td><td>{{1.record.marches}}</td></tr>
    <tr><td style="color:#888;">Compte</td><td>{{1.record.capital}}</td></tr>
    <tr><td style="color:#888;">Dispo</td><td>{{1.record.disponibilite}}</td></tr>
  </table>
</div>
```

Objet suggéré : `Nouvelle candidature — {{1.record.prenom}}`

**C. Faire apprendre la structure à Make**

Make ne connaît les champs qu'après avoir reçu une première fois la donnée. Si le
panneau de mapping est vide, c'est ça :

1. Dans Make, clique **Run once** — le scénario passe en attente
2. Dans Supabase → *Table Editor* → `formation_candidatures` → **Insert row**, remplis
   deux ou trois cases au hasard → *Save*
3. Make reçoit la ligne et affiche désormais tous les champs sous `record`

Cette astuce évite d'avoir à passer par le site pour tester.

**D. Vérifier

Remplis une fausse candidature sur le site. L'email doit arriver dans la minute. S'il
n'arrive pas : Supabase → Webhooks → onglet des logs, le code de réponse y est affiché.

Supabase envoie un objet JSON dont les réponses se trouvent dans `record`. Exemple :
`record.prenom`, `record.age`, `record.experience`, `record.disponibilite`.

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
