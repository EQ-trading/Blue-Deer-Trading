# Blue Deer Trading Platform

A multi-component trading platform with Discord bot integration, web dashboard, and automated screenshot reporting.

## Project Overview

This repository contains three main active components:

1. **Frontend** - Next.js web application for viewing trades and portfolio
2. **Discord Bot** - Python/FastAPI bot for trade logging and Discord integration
3. **Screenshotter** - Automated screenshot tool that runs daily and posts to Discord

> **Note:** The following components are archived and no longer actively maintained:
> - `agentic_trading_system/` - AI trading system (archived)
> - `ai-agent/` - AI agent components (archived)  
> - `trade_log_parser/` - One-time tool for parsing trade logs from images (archived)

---

## Quick Start for New Owner

### Prerequisites
- Node.js 18+ (for frontend)
- Python 3.12+ (for Discord bot and screenshotter)
- Git
- Supabase account
- Discord bot token
- Vercel account (for frontend deployment)
- GitHub account (for screenshotter automation)

---

## 1. Supabase Setup

### Transferring Ownership

The current owner should transfer the Supabase project:

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Select the project
3. Go to **Project Settings** → **General**
4. Click **Transfer Project**
5. Enter the new owner's email
6. The new owner accepts the transfer via email

### After Transfer - Update Environment Variables

Once transferred, the new owner will need to update these values in all `.env` files:

- `NEXT_PUBLIC_SUPABASE_URL` (new project URL)
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` (new anon key)
- `SUPABASE_DB_HOST` (new database host)
- `SUPABASE_DB_PASSWORD` (new database password)

**Where to find these:**
- Project URL and Anon Key: Supabase Dashboard → Project Settings → API
- Database Connection Info: Supabase Dashboard → Project Settings → Database → Connection Info

---

## 2. Frontend Deployment (Vercel)

The frontend is a Next.js 14 application.

### Local Development

```bash
cd frontend
npm install
cp .env.example .env.local
# Edit .env.local with your Supabase credentials
npm run dev
```

### Deploy to Vercel

1. Push code to GitHub
2. Go to [vercel.com](https://vercel.com) and import your repository
3. Select the `frontend/` directory as the root
4. Add environment variables in Vercel dashboard:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. Deploy!

**Note:** Update `SITE_URL` in screenshotter environment variables after deploying.

---

## 3. Discord Bot Hosting

### Option A: Render (Recommended - Free) + UptimeRobot

**Pros:** Free tier, simple deployment via Blueprint, infrastructure as code
**Cons:** Bot sleeps after 15 minutes (easily fixed with UptimeRobot)

**Setup Steps:**

1. Go to [render.com](https://render.com) and create an account
2. Fork this repository to your GitHub account
3. Click **New** → **Blueprint**
4. Connect your GitHub repository
5. Render will automatically detect the `render.yaml` configuration
6. Add environment variables (these are the secret ones not in render.yaml):
   ```
   DISCORD_TOKEN=your_bot_token
   SUPABASE_URL=your_supabase_url
   SUPABASE_KEY=your_supabase_anon_key
   SUPABASE_DB_HOST=your_db_host
   SUPABASE_DB_PASSWORD=your_db_password
   SUPABASE_DB_NAME=postgres
   SUPABASE_DB_PORT=5432
   SUPABASE_DB_USER=postgres
   JWT_SECRET_KEY=generate_a_random_secret
   ```
7. Deploy!

**Keep Bot Alive with UptimeRobot (Required):**

1. Go to [uptimerobot.com](https://uptimerobot.com)
2. Create free account
3. Add HTTP monitor:
   - **URL:** `https://your-service-url.onrender.com/health`
   - **Interval:** Every 5 minutes
4. Bot stays awake 24/7!

### Option B: Railway - $5/month

**Pros:** Always-on (no UptimeRobot needed), simple, reliable
**Cons:** $5/month cost

**Setup Steps:**

1. Go to [railway.app](https://railway.app) and sign up
2. Click **New Project** → **Deploy from GitHub repo**
3. Select this repository
4. Add a new service with root directory: `discord_bot/`
5. Add all environment variables (same as above)
6. Set start command: `make run`
7. Deploy!

**Cost:** Free (with UptimeRobot setup)

### Option C: VPS (Self-Hosted)

If you prefer to self-host on your own VPS:

1. SSH into server: `ssh root@your-server-ip`
2. Clone repository and navigate to `discord_bot/`
3. Set up `.env` file
4. Run: `bash start_bot.sh`

**Cost:** VPS hosting fees ($5-10/month)

---

## 4. Screenshotter Setup (GitHub Actions)

The screenshotter runs automatically via GitHub Actions at 5 PM EST daily.

### Setup Steps

1. The workflow file is already in `.github/workflows/screenshotter.yml`
2. Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**
3. Add the following repository secrets:

   ```
   SITE_URL=https://your-frontend-url.vercel.app
   SITE_PASSWORD=bluedeer
   DISCORD_WEBHOOK_DAY_TRADER=https://discord.com/api/webhooks/...
   DISCORD_WEBHOOK_SWING_TRADER=https://discord.com/api/webhooks/...
   DISCORD_WEBHOOK_LONG_TERM_TRADER=https://discord.com/api/webhooks/...
   DISCORD_WEBHOOK_FULL_PORTFOLIO=https://discord.com/api/webhooks/...
   DEBUG_WEBHOOK_DAY_TRADER=https://discord.com/api/webhooks/...
   DEBUG_WEBHOOK_SWING_TRADER=https://discord.com/api/webhooks/...
   DEBUG_WEBHOOK_LONG_TERM_TRADER=https://discord.com/api/webhooks/...
   DEBUG_WEBHOOK_FULL_PORTFOLIO=https://discord.com/api/webhooks/...
   ```

4. The workflow will run automatically every day at 5 PM EST
5. You can also trigger it manually from **Actions** → **Daily Screenshotter** → **Run workflow**

### What's Included in the Action

- Firefox browser installation
- Geckodriver setup
- Python dependencies (selenium, requests, pyvirtualdisplay, python-dotenv)
- Virtual display for headless operation
- Automatic Discord webhook posting

---

## Environment Variables Reference

### Frontend (`frontend/.env.local`)
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
```

### Discord Bot (`discord_bot/.env`)
```env
DISCORD_TOKEN=your_discord_bot_token
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_KEY=your-supabase-anon-key
SUPABASE_DB_HOST=db.xxxxxxxxxx.supabase.co
SUPABASE_DB_PASSWORD=your-database-password
SUPABASE_DB_NAME=postgres
SUPABASE_DB_PORT=5432
SUPABASE_DB_USER=postgres
ENVIRONMENT=production
API_HOST=0.0.0.0
API_PORT=8000
JWT_SECRET_KEY=your_jwt_secret_key
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### Screenshotter (GitHub Secrets)
```env
SITE_URL=https://your-site-url.vercel.app
SITE_PASSWORD=bluedeer
DISCORD_WEBHOOK_DAY_TRADER=...
DISCORD_WEBHOOK_SWING_TRADER=...
DISCORD_WEBHOOK_LONG_TERM_TRADER=...
DISCORD_WEBHOOK_FULL_PORTFOLIO=...
DEBUG_WEBHOOK_DAY_TRADER=...
DEBUG_WEBHOOK_SWING_TRADER=...
DEBUG_WEBHOOK_LONG_TERM_TRADER=...
DEBUG_WEBHOOK_FULL_PORTFOLIO=...
```

---

## Cost Summary

| Service | Cost | Notes |
|---------|------|-------|
| **Supabase** | Free tier | Generous free tier for this project size |
| **Vercel** | Free tier | Hobby plan (free) sufficient |
| **Discord Bot (Render)** | **Free** | **Recommended** - uses UptimeRobot to stay awake |
| **Discord Bot (Railway)** | $5/month | Alternative - always-on without UptimeRobot |
| **Screenshotter (GitHub Actions)** | Free | 2000 minutes/month free |
| **Total (Recommended)** | **$0/month** | Render + UptimeRobot + all free tiers |
| **Total (Alternative)** | $5/month | Railway + all other free tiers |

---

## Handoff Checklist

### Current Owner Should:
- [ ] Transfer Supabase project ownership
- [ ] Provide Discord bot token
- [ ] Revoke/update webhook URLs (if desired)
- [ ] Share any additional secrets not in code

### New Owner Should:
- [ ] Accept Supabase transfer
- [ ] Collect all new Supabase credentials
- [ ] Update all `.env` files and GitHub secrets
- [ ] Deploy frontend to Vercel
- [ ] Set up Discord bot hosting (Render recommended, or Railway)
- [ ] Configure GitHub Actions secrets for screenshotter
- [ ] Test all components:
  - [ ] Frontend loads correctly
  - [ ] Discord bot responds to commands
  - [ ] Screenshots post to Discord
- [ ] Archive `agentic_trading_system/`, `ai-agent/`, `trade_log_parser/` folders if desired

---

## Troubleshooting

### Frontend not connecting to Supabase
- Check that Supabase credentials are correct
- Ensure Supabase project is active (not paused)
- Check browser console for CORS errors

### Discord bot not responding
- Verify `DISCORD_TOKEN` is valid
- Check bot has necessary permissions in Discord
- Review Railway/Render logs for errors

### Screenshots not posting
- Check GitHub Actions logs for errors
- Verify Discord webhook URLs are valid
- Check that `SITE_URL` and `SITE_PASSWORD` are correct
- Review uploaded artifacts in failed runs for debug screenshots

---

## Project Structure

```
Blue-Deer-Trading/
├── frontend/              # Next.js web application
│   ├── src/
│   ├── supabase/         # Supabase edge functions
│   └── .env.example
├── discord_bot/          # Discord bot + FastAPI backend
│   ├── backend/
│   ├── alembic/          # Database migrations
│   └── .env.example
├── screenshotter/        # Automated screenshot tool
│   ├── screenshotter.py
│   └── .env.example
├── .github/workflows/    # GitHub Actions
│   └── screenshotter.yml
├── agentic_trading_system/  # [ARCHIVED]
├── ai-agent/               # [ARCHIVED]
├── trade_log_parser/       # [ARCHIVED]
└── README.md
```

---

## Support

For questions or issues:
1. Check the troubleshooting section above
2. Review logs in Railway/Render/GitHub Actions
3. Check Discord webhook URLs are valid
4. Verify all environment variables are set correctly

---

## License

MIT

---

**Last Updated:** February 2026  
**Original Author:** Dylan Zeller  
**Purpose:** Handoff documentation for new project owner
