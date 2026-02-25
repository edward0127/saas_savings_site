# Tudouke Marketing Site

Modern, conversion-focused marketing website for an affordable AI-assisted website and app delivery business.

## Stack

- Ruby on Rails 8.1
- SQLite3
- Tailwind CSS
- Hotwire (Turbo + Stimulus)
- RSpec
- RuboCop
- dotenv-rails
- Docker + Docker Compose

## What is implemented

- Public marketing pages:
  - `/`
  - `/how-it-works`
  - `/what-we-replace` (menu label: "What We Build")
  - `/pricing`
  - `/case-studies` (placeholder page, currently hidden from main navigation)
  - `/about`
  - `/contact`
  - `/privacy`
  - `/terms`
- Reusable Tailwind components:
  - Navbar, hero, feature cards, pricing cards, FAQ accordion, footer
- Lead capture backend:
  - `Lead` model with validations
  - Turbo-friendly submission flow
  - Honeypot spam field + basic session rate limiting
  - Optional email notification to owner
- Admin backend:
  - `/admin/leads` (HTTP Basic protected)
  - Lead detail page
  - CSV export (`/admin/leads/export.csv`)
  - `/admin/settings` for owner email + SMTP config
- SEO/quality:
  - Per-page title/meta description
  - Canonical URLs + robots directives
  - Basic OpenGraph tags
  - JSON-LD structured data (Organization, WebSite, Service, FAQPage, ContactPage)
  - `sitemap.xml`
  - `robots.txt`
  - `llms.txt` for AI crawler context
  - Styled `public/404.html` and `public/500.html`
  - Analytics script hook via env variable
- Tests:
  - Lead model validation specs
  - Request specs for lead success/failure
  - Request specs for admin auth + CSV export

## Prerequisites

- Ruby 3.3.x (matches `.ruby-version`)
- Bundler
- SQLite3

## Environment variables

Copy `.env.example` to `.env` and update values:

```bash
cp .env.example .env
```

Important variables:

- `ADMIN_USER`, `ADMIN_PASS` (HTTP Basic auth for `/admin/*`)
- `OWNER_EMAIL` (lead notification target fallback)
- `MAIL_FROM_EMAIL`
- `APP_HOST`, `APP_PORT`, `APP_PROTOCOL`
- `SMTP_*` (optional; can also be managed in `/admin/settings`)
- `ANALYTICS_SCRIPT_SRC` (optional script URL)
- `FORCE_SSL`, `ASSUME_SSL` (production)

## Local setup

Install gems:

```bash
bundle install
```

Prepare database:

```bash
bin/rails db:prepare
```

Build Tailwind once:

```bash
bin/rails tailwindcss:build
```

Start server:

```bash
bin/rails s
```

Open: `http://localhost:3000`

Admin: `http://localhost:3000/admin/leads`

## Tests

Run all specs:

```bash
bundle exec rspec
```

Run linting:

```bash
bundle exec rubocop
```

## Docker

The app includes a production-oriented `Dockerfile` and `docker-compose.yml` using SQLite storage volume.

1. Create `.env` (include `RAILS_MASTER_KEY` for production mode).
2. Build and run:

```bash
docker compose up --build
```

```bash
SHA=$(git rev-parse --short HEAD)
docker buildx build --platform linux/amd64 \
  -t ghcr.io/edward0127/saas_savings_site:$SHA \
  -t ghcr.io/edward0127/saas_savings_site:latest \
  --push .
```

App will be available at `http://localhost:3000`.

## Notes

- Lead notifications use `LeadMailer` with dynamic SMTP options from `AppSetting`.
- If SMTP is not configured, leads are still saved successfully.
- Tailwind/Hotwire interactions are implemented with importmap and Stimulus controllers (`accordion`, `menu`).

## Run on server

docker compose down
docker compose pull web
docker compose up -d --force-recreate
docker ps
docker compose logs --tail=100 web
