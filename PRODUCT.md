# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

**Primary: farmers and rural communities.** Rural producers, community members and local organizations in the region served by UTFPR Campus Santa Helena (western Paraná). They come to see what the group is doing in their territory: extension projects, events, news and practical results. When audience needs conflict, design decisions favor this group first (confirmed).

**Secondary public audiences** (named in the site's own copy, not ranked further): academics and students browsing publications and members; partner institutions and funders judging the group's work; the general public.

**Admin users: a few coordinators.** One or two coordinators or technical people publish all content (news, projects, events, publications, members) through `/admin`, mostly on desktop (confirmed).

## Product Purpose

Rede Campo Online is the public website and content platform of Rede Campo, a research and extension group founded in 2021 at UTFPR Campus Santa Helena, focused on technologies applied to sustainable rural development.

It exists to give the group its own digital space: centralize its output, keep its institutional memory, and reach people outside academia. Before it, the group's work circulated through informal channels (WhatsApp, Instagram). Success means the group's projects, publications and actions are visible, findable and durable, and that rural communities can actually reach and use them.

## Positioning

Taken from the site's existing copy (not separately confirmed): the university goes to the field to build together with farmers, not only to study them. The group works where science meets territory, on rural properties and in communities, and shares results openly (open science). Its claim is regional reference in rural technology extension, rooted in real partnerships with producers and organizations in the region.

## Operating Context

- Public area: home, about us, news, projects (with team, events, publications, gallery), events (upcoming and recent, with location and media), publications (articles, books, book chapters, theses/academic works), members.
- Admin panel at `/admin`, behind JWT login, managing news, projects, events, publications and members, including media upload with crop.
- Content arrives from the group's own REST API; the front end holds no content of its own beyond fixed institutional copy (about, history, mission, vision, values).
- Publication detail pages show the original abstract plus an English version auto-translated at view time from Portuguese.

## Capabilities and Constraints

- Flutter Web only (Flutter 3.16.4, Dart 3.2.3); no Android or iOS targets. Renders to canvas, so DOM-based tooling (live variant mode, HTML/CSS detectors) does not apply.
- Every screen ships separate desktop and mobile versions; breakpoints at 400 (mobile), 768 (tablet), 1024 (desktop) via `responsive_framework`.
- State with MobX, DI with GetIt, routing with `go_router`. Paged listings extend `PagedStore<T>`; admin listings reuse generic `AdminEntityList*` widgets; uploads use `MediaUploadField`.
- Terminology in the product: Notícias, Projetos, Eventos, Publicações (Artigos, Livros, Capítulos de livro, Trabalhos acadêmicos), Membros, Parceiros, Áreas de pesquisa.
- Built as an undergraduate thesis (TCC); the repository is public for portfolio and academic demonstration only, not open source. The Rede Campo group runs its own modified version under a separate agreement.
- Production API URL is not configured yet in the repository.

## Brand Commitments

- Keep the existing Rede Campo logo files as-is: `assets/images/logo.png`, `logo_horizontal.png`, `logo_icon.png`, `logo_white.png` (confirmed binding).
- Portuguese (pt-BR) is the primary language of the product. English appears only as auto-translated publication abstracts (confirmed binding).
- Not binding: UTFPR visual identity rules do not govern the site's design (user did not select them).

## Evidence on Hand

- Institutional copy in code: home header tagline ("Pesquisa, inovação e extensão em desenvolvimento rural"), about-us text, history, mission, vision and values.
- Partner logos: `assets/images/utfpr.png`, `idr.png` (IDR-Paraná), `senar.png`.
- Metric highlights hardcoded in `metric_highlights_widget.dart`: +60 members across Brazil, +100 articles/books/dissertations, +10 extension projects in progress, +5 applications developed. These figures are not confirmed by the user; verify with the group before reusing them anywhere new.
- All news, projects, events, publications, members and images come from the API. No testimonials, case studies, press coverage or farmer quotes exist in the repository; future work must not invent them.

## Product Principles

1. **Reach the field first.** When a choice helps academics but costs farmers and communities clarity or access, the farmer's side wins.
2. **Plain Portuguese over academic register.** Public-facing text and labels should read clearly for someone outside the university; scholarly detail stays available on publication pages, not on the way to them.
3. **The record is the product.** Projects, publications and events are the group's institutional memory; they must stay findable, complete and durable, not buried behind feeds.
4. **Show real work, never staged proof.** Everything shown comes from the group's actual projects, people and partners.
5. **Publishing stays cheap for a small team.** A few coordinators run all content; admin flows should favor speed and predictability over options.

## Accessibility & Inclusion

The primary audience (farmers and rural communities) implies phone-first use, readers with varied literacy and academic familiarity, and possibly weak or metered mobile connections in rural areas. No formal standard (such as WCAG level) has been set; recording that as an open decision.
