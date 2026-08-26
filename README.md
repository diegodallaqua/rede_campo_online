# Rede Campo Online

Repositório oficial da **Plataforma Rede Campo Online**, um site responsivo (Flutter Web) voltado ao grupo de pesquisa Rede Campo.

A aplicação é um front-end que consome uma API REST própria e oferece:

- **Área pública:** home, sobre nós, notícias, projetos, eventos, publicações (artigos, teses, livros e capítulos de livros) e membros.
- **Painel administrativo** (`/admin`, protegido por login JWT): gerenciamento de notícias, projetos, eventos, publicações e membros.

## Pré-requisitos

Para compilar e executar este projeto, você precisará das seguintes ferramentas instaladas em sua máquina:

- **Flutter:** Versão 3.16.4 - canal `stable` (use o [Puro](https://puro.dev/) para gerenciar as versões do Flutter)
- **Dart:** Versão 3.2.3 (já incluída no Flutter 3.16.4)
  - Restrição declarada em `pubspec.yaml`: `sdk: '>=3.2.3 <4.0.0'`
- **Navegador Chrome / Chromium** (alvo de execução e depuração do Flutter Web)
- **API Rede Campo Online** em execução (back-end REST consumido pelo app)

> ⚠️ **Alvo suportado:** este projeto é compilado apenas para **Web**. O repositório não contém as pastas `android/` e `ios/`, portanto não são necessários Java, Gradle, AGP ou Kotlin.

📌 **Trecho de exemplo do `pubspec.yaml`:**

```yaml
environment:
  sdk: '>=3.2.3 <4.0.0'
```

📌 **Fixando a versão do Flutter com o Puro:**

```bash
puro create rede_campo 3.16.4
puro use rede_campo
```

## Configuração do ambiente

O endereço da API e as rotas são centralizados em `lib/core/global/constants/api_constants.dart`:

```dart
enum BaseEnvironment {
  development('http://127.0.0.1:3308');
  //production('https://');

  final String baseURL;

  const BaseEnvironment(this.baseURL);
}

final baseURL = BaseEnvironment.development.baseURL;
```

Antes de subir a aplicação em outro ambiente:

1. Descomente/ajuste a entrada `production` do enum `BaseEnvironment` com a URL pública da API.
2. Troque `final baseURL = ...` para o ambiente desejado.
3. Informe o segredo do JWT via `--dart-define` (a constante `jwtSecret` é lida de `String.fromEnvironment('JWT_SECRET')`):

```bash
flutter run -d chrome --dart-define=JWT_SECRET=seu_segredo_aqui
```

## Como executar o projeto

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/diegodallaqua/rede_campo_online.git
   ```

2. **Acesse o diretório do projeto:**

   ```bash
   cd rede_campo_online
   ```

3. **Instale as dependências do Flutter:**

   ```bash
   flutter pub get
   ```

4. **Gere os arquivos do MobX (`*.g.dart`):**

   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

   Durante o desenvolvimento, para regerar automaticamente a cada alteração:

   ```bash
   flutter packages pub run build_runner watch --delete-conflicting-outputs
   ```

5. **Execute o aplicativo:**

   ```bash
   flutter run -d chrome
   ```

   Caso a API use certificado autoassinado (comum em VM interna):

   ```bash
   flutter run -d chrome --web-browser-flag=--ignore-certificate-errors
   ```

6. **Caso necessário, apague erros de geração de código:**

   ```bash
   find . -name "*.g [0-9]*.dart" -type f -delete
   ```

   No PowerShell (Windows):

   ```powershell
   Get-ChildItem -Recurse -Filter "*.g [0-9]*.dart" | Remove-Item
   ```

7. **Analisar e testar:**

   ```bash
   flutter analyze
   flutter test
   ```

8. **Testar se o servidor da API está no ar:**

   ```bash
   for pair in "development|http://127.0.0.1:3308"; do
     env=${pair%%|*}
     url=${pair#*|}
     code=$(curl -k -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")
     case "$code" in 2*|3*) state="ON";; *) state="OFF";; esac
     echo "$env ($url): $state (HTTP $code)"
   done
   ```

   Adicione o par `"production|https://<host-da-vm>:<porta>"` à lista quando o ambiente de produção estiver configurado.

## Build e publicação

```bash
flutter build web --release --dart-define=JWT_SECRET=seu_segredo_aqui
```

O resultado fica em `build/web/`. Consulte o [DEPLOY.md](DEPLOY.md) para as instruções de hospedagem na VM (Nginx, `--base-href`, HTTPS e CORS).

## Estrutura do projeto

O projeto segue uma arquitetura **feature-first** com uma camada `core/` compartilhada:

- `lib/`: todo o código-fonte em Dart.
  - `app/`: ponto de entrada e navegação.
    - `main.dart`: inicialização (injeção de dependência, locale `pt_BR`, verificação de sessão) e `MaterialApp.router` com breakpoints responsivos.
    - `router.dart`: rotas do `go_router` (`AppRoutes`) e guarda de acesso à área `/admin`.
  - `core/`: código compartilhado entre features.
    - `global/`: `injection.dart` (GetIt) e `constants/api_constants.dart` (URL base + rotas da API).
    - `models/`: modelos transversais (endereços, cidades, estados, organizações, contribuidores, papéis, token de autenticação, mídias etc.).
    - `repositories/`: repositórios transversais (endereços, organizações, áreas de pesquisa, upload de imagens, token, tradução etc.).
    - `stores/`: stores MobX base - `BaseStore`, `PagedStore<T>` (listagens paginadas), `MediaMapStore<M>`, `FilterSearchStore`, `TranslationStore` e `UserManagerStore` (sessão).
    - `ui/`: componentes reutilizáveis - `buttons/`, `forms/`, `listing_tiles/`, `sections/`, `theme/` (`CustomColors`) e `widgets/` (incluindo os genéricos de listagem administrativa em `widgets/admin/`).
    - `utils/`: utilitários puros (formatadores, placeholders, toasts, tratamento de mensagens de erro da API).
  - `features/`: uma pasta por domínio (`home`, `about_us`, `news`, `projects`, `events`, `publications`, `articles`, `books`, `book_chapters`, `thesis`, `members`, `login`, `admin`). Cada feature repete o mesmo formato interno:
    - `models/`: modelos daquele domínio.
    - `repositories/`: acesso HTTP àquele domínio.
    - `stores/`: stores MobX daquele domínio.
    - `screens/`: telas e seus `widgets/` (`sections/`, `listing/`), com versões `*_desktop_version.dart` e `*_mobile_version.dart`.
- `assets/`: imagens e fontes da aplicação (`assets/images/`, `assets/fonts/RobotoSlab.ttf`).
- `web/`: arquivos específicos da plataforma Web (`index.html`, `manifest.json`, ícones e favicon).
- `*.puml`: diagramas UML do projeto (ver seção abaixo).

## Arquitetura e principais bibliotecas

| Responsabilidade | Biblioteca / Padrão |
| --- | --- |
| Gerência de estado | `mobx` + `flutter_mobx` (stores com código gerado por `mobx_codegen`) |
| Injeção de dependência | `get_it` (`setupDependencies()` em `core/global/injection.dart`) |
| Navegação | `go_router` (rotas declaradas em `app/router.dart`) |
| Responsividade | `responsive_framework` (breakpoints: mobile 400, tablet 768, desktop 1024) |
| Comunicação HTTP | `http` + `http_parser` |
| Autenticação | `dart_jsonwebtoken` (leitura do `exp`) + `flutter_secure_storage` (persistência do token) |
| Imagens | `image_picker`, `image_cropper`, `cached_network_image` |
| Formatação | `intl`, `brasil_fields` |

Convenções que o código novo deve seguir:

- Listagens paginadas estendem `PagedStore<T>` e implementam apenas `fetchPage(int)` - não precisam de `.g.dart` próprio.
- Listagens do painel administrativo reutilizam os genéricos `AdminEntityListSection{Desktop,Mobile}Version<T>` e `AdminEntityList{Desktop,Mobile}Version<T>` (`core/ui/widgets/admin/`), parametrizados por store, textos, `itemBuilder` e `gridDelegate`.
- Upload de mídia usa `MediaUploadField`, genérico sobre a interface `MediaAttachment` (`core/models/`).
- Modelos, repositórios e stores compartilhados por mais de uma feature vivem em `core/models`, `core/repositories` e `core/stores` - nunca em `core/utils`.


## Contribuição

O padrão de branches, de commits e de código está descrito em [CONTRIBUTING.md](CONTRIBUTING.md).

Resumo do formato de commit:

- **Tipo:** `feat` (nova funcionalidade), `fix`, `refactor`, `docs`, `chore`
- **Escopo:** parte do sistema afetada (ex.: `admin`, `news`, `core`)
- **Título:** curto e descritivo (< 72 caracteres)
- **Corpo:**
  - Parágrafo inicial explicando o "porquê" e a visão geral
  - Lista de modificações principais (arquivos + mudanças)
  - Lista de funcionalidades implementadas
  - Seção de testes realizados

## Licença

Projeto acadêmico desenvolvido para o grupo de pesquisa Rede Campo. A licença ainda não foi definida - até que um arquivo `LICENSE` seja adicionado ao repositório, todos os direitos são reservados aos autores.
