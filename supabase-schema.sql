-- ═══════════════════════════════════════════════════════════
-- Candidatures à l'accompagnement (page site/formation.html)
-- À exécuter UNE SEULE FOIS dans le SQL Editor de ton projet Supabase
-- (supabase.com → ton projet → SQL Editor → coller → Run)
-- ═══════════════════════════════════════════════════════════

create table if not exists public.formation_candidatures (
  id            uuid primary key default gen_random_uuid(),
  created_at    timestamptz not null default now(),

  -- Identité
  prenom        text not null check (char_length(prenom) between 1 and 80),
  nom           text          check (char_length(nom) <= 80),
  email         text not null check (char_length(email) between 5 and 160),
  telephone     text          check (char_length(telephone) <= 40),
  reseau        text          check (char_length(reseau) <= 120),

  -- Profil
  age           text          check (char_length(age) <= 40),
  situation     text          check (char_length(situation) <= 40),
  experience    text          check (char_length(experience) <= 120),
  marches       text          check (char_length(marches) <= 80),
  capital       text          check (char_length(capital) <= 80),
  disponibilite text          check (char_length(disponibilite) <= 80),

  -- Contexte
  page          text          check (char_length(page) <= 300),

  -- Ton suivi à toi (à éditer depuis le Table Editor de Supabase)
  statut        text not null default 'nouveau',   -- nouveau · appel_prévu · accepté · refusé
  notes         text
);

-- Les candidatures les plus récentes en premier
create index if not exists formation_candidatures_created_at_idx
  on public.formation_candidatures (created_at desc);

-- ── Sécurité ──────────────────────────────────────────────
-- Le site public peut UNIQUEMENT insérer une candidature.
-- Personne ne peut lire, modifier ni supprimer avec la clé publique :
-- tu consultes les candidatures depuis le tableau de bord Supabase
-- (Table Editor), qui utilise la clé de service.
alter table public.formation_candidatures enable row level security;

drop policy if exists "candidature publique" on public.formation_candidatures;
create policy "candidature publique"
  on public.formation_candidatures
  for insert
  to anon
  with check (true);

-- ── Table déjà créée avant l'ajout de l'âge et de la situation ? ──
-- Exécute uniquement ces deux lignes, elles ne cassent rien :
alter table public.formation_candidatures add column if not exists age text;
alter table public.formation_candidatures add column if not exists situation text;

-- ── Tu avais créé la table avant ? ──
-- Elle contient encore les colonnes objectif, blocage, format et source :
-- les questions correspondantes ont été retirées du formulaire, ces colonnes
-- resteront simplement vides. Rien à faire, sauf si tu veux faire le ménage :
--   alter table public.formation_candidatures drop column if exists objectif;
--   alter table public.formation_candidatures drop column if exists blocage;
--   alter table public.formation_candidatures drop column if exists format;
--   alter table public.formation_candidatures drop column if exists source;

-- ═══════════════════════════════════════════════════════════
-- OPTIONNEL — recevoir un email à chaque candidature
-- Supabase → Database → Webhooks → Create a new hook
--   Table   : formation_candidatures
--   Events  : Insert
--   Type    : HTTP Request (POST) vers ton service d'email
--             (Zapier, Make, n8n, Resend…) ou une Edge Function.
-- Sans ça, tu retrouves toutes les candidatures dans Table Editor.
-- ═══════════════════════════════════════════════════════════
