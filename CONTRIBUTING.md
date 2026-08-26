# Guia de contribuição - Rede Campo Online

Este documento descreve o fluxo de trabalho, o padrão de commits e as convenções de código do projeto.

## Preparando o ambiente

Siga a seção **Pré-requisitos** e **Como executar o projeto** do [README.md](README.md). Em resumo:

```bash
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

Mantenha o `build_runner` em modo `watch` enquanto altera stores MobX:

```bash
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

## Fluxo de trabalho

1. Atualize a `main` local: `git pull origin main`.
2. Crie uma branch a partir da `main` seguindo o padrão `<tipo>/<descrição-curta>`:
   - `feat/painel-admin-membros`
   - `fix/token-expirado-login`
   - `refactor/stores-listagem`
   - `docs/readme-deploy`
3. Faça commits pequenos e coesos (ver formato abaixo).
4. Antes de abrir o Pull Request, garanta que:

   ```bash
   flutter analyze
   flutter test
   ```

   terminam sem erros e que os arquivos `*.g.dart` gerados foram commitados junto às stores que os originaram.
5. Abra o Pull Request para a `main` descrevendo o "porquê", as mudanças principais e os testes realizados.

## Padrão de commits

Formato:

```
<tipo>(<escopo>): <título curto, < 72 caracteres>

<parágrafo explicando o porquê e a visão geral da mudança>

Modificações principais:
- <arquivo/módulo>: <o que mudou>

Funcionalidades implementadas:
- <funcionalidade>

Testes realizados:
- <o que foi validado e como>
```

**Tipos aceitos:**

| Tipo | Uso |
| --- | --- |
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `refactor` | Mudança interna sem alterar comportamento |
| `docs` | Documentação (`.md`, comentários, diagramas) |
| `style` | Formatação, sem impacto em lógica |
| `chore` | Dependências, configuração, build |

**Escopos comuns:** `core`, `admin`, `news`, `projects`, `events`, `publications`, `members`, `login`, `router`, `deploy`.

Exemplo:

```
feat(admin): criação do módulo de membros do painel administrativo

Adiciona o CRUD de membros ao painel administrativo e padroniza as stores
de listagem do admin em torno de PagedStore, eliminando a duplicação que
existia entre os módulos de notícias, projetos e eventos.

Modificações principais:
- lib/features/admin/members/: telas de listagem e criação de membros
- lib/core/stores/paged_store.dart: extração do fluxo de paginação comum
- lib/core/ui/widgets/admin/: listagem genérica AdminEntityList<T>

Funcionalidades implementadas:
- Listagem paginada de membros
- Cadastro e edição de membro com upload de foto

Testes realizados:
- flutter analyze sem erros
- Cadastro, edição e remoção validados contra a API local
```

## Convenções de código

### Arquitetura

O projeto é **feature-first**: cada domínio em `lib/features/<feature>/` tem `models/`, `repositories/`, `stores/` e `screens/`. Código usado por mais de uma feature vai para `lib/core/`.

- `core/models`, `core/repositories`, `core/stores`: artefatos compartilhados.
- `core/utils`: **apenas** utilitários puros (formatadores, placeholders, toasts, tratamento de mensagens de erro). Não coloque modelos, repositórios ou stores aqui.
- `core/ui`: componentes visuais reutilizáveis.

### Antes de criar um widget ou store novo

O repositório passou por uma refatoração grande de deduplicação. Reutilize as abstrações existentes em vez de copiar uma feature vizinha:

- **Listagem paginada:** estenda `PagedStore<T>` (`core/stores/paged_store.dart`) e implemente apenas `fetchPage(int)`. Stores que só estendem `PagedStore` não precisam de `.g.dart` próprio.
- **Mapa de mídias:** use `MediaMapStore<M>` (MobX manual, sem codegen).
- **Listagem administrativa:** use `AdminEntityListSection{Desktop,Mobile}Version<T>` e `AdminEntityList{Desktop,Mobile}Version<T>` (`core/ui/widgets/admin/`), parametrizados por store, textos, `itemBuilder` e `gridDelegate` (`gridDelegate` nulo = `ListView`).
- **Upload de mídia:** use `MediaUploadField` (`core/ui/forms/`), genérico sobre a interface `MediaAttachment` (`core/models/`), com o modelo `PendingMedia`.
- **Seções de página de detalhe:** reutilize `authors_section.dart`, `abstract_section.dart` e `ContributorsCarousel` de `core/ui/`.

### Estado (MobX)

- Stores anotadas com `@observable`, `@action` e `@computed` precisam do arquivo `part '<nome>.g.dart'` e da execução do `build_runner`.
- Stores globais (sessão, login, painel admin) são registradas em `core/global/injection.dart` via `getIt.registerLazySingleton`.
- Acesse-as com `getIt<MinhaStore>()` - não instancie manualmente stores globais.

### Rotas

Toda rota nova deve ser declarada como constante em `AppRoutes` (`lib/app/router.dart`) e referenciada por essa constante, nunca por string literal espalhada pelas telas. Rotas sob `/admin` são protegidas pela guarda de sessão.

### API

Endpoints ficam centralizados em `lib/core/global/constants/api_constants.dart`. Não escreva URLs literais dentro de repositórios ou telas - adicione uma constante nesse arquivo.

### Responsividade

Telas com layouts distintos seguem o par `*_desktop_version.dart` / `*_mobile_version.dart`. Os breakpoints são definidos em `lib/app/main.dart` (mobile 400, tablet 768, desktop 1024).

### Estilo

- Siga as regras de `analysis_options.yaml` (`flutter_lints`).
- Formate com `dart format .` antes do commit.
- Textos de interface em **português do Brasil**; nomes de classes, métodos e variáveis em **inglês**.
- Cores vêm de `CustomColors` (`core/ui/theme/custom_colors.dart`) - não use literais `Color(0xFF...)` nas telas.
