# Les photos du questionnaire

Dépose tes photos ici. Le panneau à droite du formulaire change d'image
à chaque fois que le visiteur répond à une question.

Une photo par étape, nommées dans l'ordre. Les noms doivent être exacts :

```
01.jpg   Ton prénom et ton âge
02.jpg   Sur quelle adresse mail je peux te contacter ?
03.jpg   Sur quel numéro je peux te joindre ?
04.jpg   Aujourd'hui, t'en es où dans le trading ?
05.jpg   Qu'est-ce que tu trades ?
06.jpg   Où en est ton compte ?
07.jpg   Quelle est ta situation actuelle ?
08.jpg   Combien de temps tu peux y consacrer ?
09.jpg   Tu veux en être où dans 6 mois ?
10.jpg   Qu'est-ce qui te bloque le plus ?
11.jpg   Quel format t'intéresse ?
12.jpg   Comment tu m'as connu ?
13.jpg   Dernière étape
```

## Ce qu'il faut savoir

**Tu n'es pas obligé de toutes les fournir d'un coup.** Une photo qui manque
retombe automatiquement sur `../setup.jpg`. Tu peux en déposer trois
aujourd'hui et le reste plus tard, le site ne cassera pas.

**Format.** Le panneau est vertical sur ordinateur et horizontal sur mobile,
et l'image est recadrée au centre. Une photo verticale ou carrée passe bien ;
une photo très large sera coupée sur les côtés.

**Poids.** Vise moins de 500 Ko par photo. Le site n'en charge que deux à la
fois (celle affichée et la suivante), mais treize photos de 2 Mo restent
treize photos de 2 Mo pour qui remplit tout le formulaire.

**Le bord gauche de l'image est assombri** par un dégradé, pour que le
formulaire reste lisible. Ne mets rien d'important à gauche de la photo.

**Extension.** `.jpg` uniquement, en minuscules. `01.JPG` ou `01.png` ne
seront pas trouvés.

## Ajouter une photo depuis GitHub

Ouvre ce dossier sur github.com → **Add file** → **Upload files** →
glisse tes images → **Commit changes**. Vercel redéploie tout seul.

Si ton fichier s'appelle `IMG_4821.JPG`, renomme-le en `01.jpg` avant de
l'envoyer, ou clique dessus après l'envoi → l'icône crayon → change le nom.

## Changer le nombre d'étapes

Si tu ajoutes ou retires une question dans le formulaire, la liste des
photos suit toute seule : le site en attend autant qu'il y a d'étapes.
Renomme simplement tes fichiers pour qu'ils restent numérotés à la suite.
