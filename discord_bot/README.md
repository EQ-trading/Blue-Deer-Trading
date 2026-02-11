# Blue Deer Trading Discord Bot

A Discord bot built with Python, FastAPI, and SQLAlchemy for trade logging, portfolio management, and Discord integration.

## Overview

This bot serves as the backend for the Blue Deer Trading platform:
- Receives trade entries from Discord commands
- Stores trade data in Supabase (PostgreSQL)
- Provides FastAPI endpoints for the frontend
- Manages user authentication with JWT
- Handles database migrations with Alembic

## Features

- **Discord Commands:** Log trades directly from Discord
- **REST API:** FastAPI endpoints for frontend integration
- **Database:** Supabase PostgreSQL with SQLAlchemy ORM
- **Authentication:** JWT-based auth system
- **Migrations:** Alembic for database schema management
- **Multiple Trader Groups:** Supports Day, Swing, and Long Term traders

## Prerequisites

- Python 3.12+
- Discord bot token
- Supabase account with project transferred
- (Optional) PM2 for process management

## Setup

### 1. Navigate to Discord Bot Directory

```bash
cd discord_bot
```

### 2. Create Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r backend/app/requirements.txt
```

Or use the Makefile:
```bash
make install_deps
```

### 4. Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your values:

```env
# Discord Bot Token (from Discord Developer Portal)
DISCORD_TOKEN=your_discord_bot_token

# Supabase Configuration
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_KEY=your-supabase-anon-key

# Supabase Database Connection
# Get from Supabase Dashboard → Project Settings → Database → Connection Info
SUPABASE_DB_HOST=db.xxxxxxxxxx.supabase.co
SUPABASE_DB_PASSWORD=your-database-password
SUPABASE_DB_NAME=postgres
SUPABASE_DB_PORT=5432
SUPABASE_DB_USER=postgres

# Environment
ENVIRONMENT=production  # or development
FASTAPI_TEST=false

# API Configuration
API_HOST=0.0.0.0
API_PORT=8000

# Security (generate a random string)
JWT_SECRET_KEY=your-super-secret-jwt-key
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

**Getting your Discord Bot Token:**
1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Select your application
3. Go to **Bot** section
4. Click **Reset Token** (if needed)
5. Copy the token

**Getting Supabase Credentials:**
- After accepting the Supabase project transfer
- Project Settings → API (for URL and Anon Key)
- Project Settings → Database → Connection Info (for DB connection)

### 5. Initialize Database

```bash
make init_db
```

This creates the local SQLite database for development (optional).

For production (Supabase), the tables should already exist from the transfer.

### 6. Run Database Migrations

```bash
# Check current status
make db-check

# Run migrations
make db-upgrade
```

### 7. Run the Bot

#### Option A: Direct Python

```bash
make run
```

Or manually:
```bash
cd backend
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

#### Option B: Using PM2 (Production)

Install PM2 globally:
```bash
npm install -g pm2
```

Use the start script:
```bash
bash start_bot.sh
```

This will:
1. Create virtual environment if needed
2. Install dependencies
3. Start the bot with PM2 (auto-restart on crash)

Check status:
```bash
pm2 status
pm2 logs BlueDeerTradingBot
```

## Project Structure

```
discord_bot/
├── backend/
│   ├── app/
│   │   ├── main.py              # FastAPI application entry
│   │   ├── bot.py               # Discord bot implementation
│   │   ├── models.py            # SQLAlchemy database models
│   │   ├── crud.py              # Database CRUD operations
│   │   ├── schemas.py           # Pydantic schemas
│   │   ├── database.py          # Database connection setup
│   │   ├── supabase_client.py   # Supabase integration
│   │   ├── init_db.py           # Database initialization
│   │   ├── cogs/                # Discord bot command groups
│   │   │   ├── trade_commands.py
│   │   │   └── ...
│   │   └── requirements.txt     # Python dependencies
│   ├── alembic/                 # Database migrations
│   │   ├── versions/            # Migration files
│   │   └── env.py              # Alembic configuration
│   ├── tests/                   # Unit tests
│   └── run.sh                   # Run script
├── db/                          # Local SQLite databases (development)
├── .env.example                # Environment template
├── Makefile                    # Build automation
├── start_bot.sh               # PM2 startup script
└── alembic.ini                # Migration configuration
```

## Available Commands

### Makefile Commands

```bash
make run              # Run the application
make run_local        # Run locally with SQLite
make test             # Run tests
make init_db          # Initialize local database
make clean            # Clean up generated files
make db-check         # Check if database is up to date
make db-upgrade       # Run database migrations
make prod-db-upgrade  # Run migrations on production (with confirmation)
db-revisions         # List all migration revisions
make help             # Show all available commands
```

## Discord Commands

Once the bot is running and invited to your Discord server:

### Trade Commands

- `!trade` - Log a new trade
- `!trades` - View recent trades
- `!portfolio` - View portfolio summary
- `!stats` - View trading statistics

### Configuration Commands

- `!setgroup [day|swing|longterm]` - Set your trader group
- `!config` - View configuration

**Note:** Check `backend/app/cogs/` for all available commands.

## API Endpoints

The bot exposes FastAPI endpoints for the frontend:

### Authentication

- `POST /token` - Get JWT token
- `POST /users/` - Create new user

### Trades

- `GET /trades/` - List all trades
- `POST /trades/` - Create new trade
- `GET /trades/{trade_id}` - Get specific trade
- `PUT /trades/{trade_id}` - Update trade
- `DELETE /trades/{trade_id}` - Delete trade

### Portfolio

- `GET /portfolio/` - Get portfolio summary
- `GET /portfolio/stats` - Get portfolio statistics

### Health

- `GET /health` - Health check endpoint

View all endpoints at `http://localhost:8000/docs` when running locally.

## Database Migrations

### Creating a New Migration

```bash
alembic revision --autogenerate -m "Description of changes"
```

### Running Migrations

```bash
# Development
make db-upgrade

# Production (with confirmation)
make prod-db-upgrade
```

### Migration Files

Located in `backend/alembic/versions/`. Each file:
- Has an upgrade function (apply changes)
- Has a downgrade function (revert changes)

**Never edit existing migration files** - create new ones instead.

## Deployment Options

### Option 1: Render (Recommended - Free) + UptimeRobot

**Pros:** Free tier available, simple deployment, infrastructure as code
**Cons:** Sleeps after 15 min inactivity (easily solved with UptimeRobot)

1. Go to [render.com](https://render.com) and create an account
2. Fork/clone this repository to your GitHub account
3. Click **New** → **Blueprint** (or **Background Worker** if Blueprint doesn't work)
4. Connect your GitHub repository
5. Render will detect the `render.yaml` configuration file
6. Add these **Environment Variables** in the Render dashboard:
   ```
   DISCORD_TOKEN=your_discord_bot_token
   SUPABASE_URL=https://your-project-ref.supabase.co
   SUPABASE_KEY=your-supabase-anon-key
   SUPABASE_DB_HOST=db.xxxxxxxxxx.supabase.co
   SUPABASE_DB_PASSWORD=your-database-password
   SUPABASE_DB_NAME=postgres
   SUPABASE_DB_PORT=5432
   SUPABASE_DB_USER=postgres
   JWT_SECRET_KEY=generate-a-random-secret-key
   ```
7. Deploy!

**Cost:** Free

#### Keep Bot Alive with UptimeRobot (Required for Free Tier)

Since Render's free tier spins down after 15 minutes of inactivity:

1. Go to [uptimerobot.com](https://uptimerobot.com)
2. Create a free account
3. Click **Add New Monitor**
4. Configure:
   - **Monitor Type:** HTTP(s)
   - **Friendly Name:** Blue Deer Trading Bot
   - **URL:** `https://your-render-service-url.onrender.com/health`
   - **Monitoring Interval:** Every 5 minutes (300 seconds)
5. Save

The bot will now stay awake 24/7!

---

### Option 2: Railway - $5/month

**Pros:** Always-on (no UptimeRobot needed), simple, reliable
**Cons:** $5/month cost

1. Go to [railway.app](https://railway.app)
2. New Project → Deploy from GitHub repo
3. Select this repository
4. Add a service with root directory: `discord_bot/`
5. Add all environment variables (same list as Render above)
6. Set start command: `make run`
7. Deploy

**Cost:** $5/month after 30-day free trial

---

### Option 3: VPS with PM2 (Previous Setup)

If you prefer to self-host on a VPS:

1. SSH into server: `ssh root@your-server-ip`
2. Clone the repository: `git clone https://github.com/yourusername/Blue-Deer-Trading.git`
3. Navigate to: `cd Blue-Deer-Trading/discord_bot`
4. Set up environment: `cp .env.example .env` and edit with your values
5. Run: `bash start_bot.sh`

**Cost:** VPS hosting fees ($5-10/month typically)

**Recommendation:** Use Render + UptimeRobot for free hosting, or Railway if you want to avoid the UptimeRobot setup.

## Environment Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `DISCORD_TOKEN` | Discord bot token | Yes |
| `SUPABASE_URL` | Supabase project URL | Yes |
| `SUPABASE_KEY` | Supabase anon key | Yes |
| `SUPABASE_DB_HOST` | Database host | Yes |
| `SUPABASE_DB_PASSWORD` | Database password | Yes |
| `SUPABASE_DB_NAME` | Database name (usually `postgres`) | Yes |
| `SUPABASE_DB_PORT` | Database port (usually `5432`) | Yes |
| `SUPABASE_DB_USER` | Database user (usually `postgres`) | Yes |
| `ENVIRONMENT` | `production` or `development` | Yes |
| `API_HOST` | API bind host (default: `0.0.0.0`) | No |
| `API_PORT` | API port (default: `8000`) | No |
| `JWT_SECRET_KEY` | Secret for JWT signing | Yes |
| `JWT_ALGORITHM` | JWT algorithm (default: `HS256`) | No |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Token expiry (default: `30`) | No |
| `FASTAPI_TEST` | Test mode flag (default: `false`) | No |

## Troubleshooting

### Bot not responding to commands

1. Check bot is online in Discord
2. Verify `DISCORD_TOKEN` is correct
3. Check bot has permissions in the Discord server
4. Review logs: `pm2 logs BlueDeerTradingBot`

### Database connection errors

1. Verify all Supabase credentials
2. Check Supabase project is active
3. Verify IP is allowlisted in Supabase (if applicable)
4. Test connection: `psql $DATABASE_URL`

### Migration errors

```bash
# Check current version
alembic current

# View migration history
make db-revisions

# Stamp to specific version (use with caution)
alembic stamp <revision_id>
```

### API returning 401 Unauthorized

- JWT token may be expired
- Check `JWT_SECRET_KEY` is consistent
- Verify `Authorization: Bearer <token>` header format

## Development

### Running Tests

```bash
make test
```

### Adding New Commands

1. Create a new cog in `backend/app/cogs/`
2. Inherit from `commands.Cog`
3. Register commands with `@commands.command()`
4. Add cog to bot in `bot.py`

Example:
```python
from discord.ext import commands

class MyCommands(commands.Cog):
    def __init__(self, bot):
        self.bot = bot
    
    @commands.command()
    async def mycommand(self, ctx):
        await ctx.send("Hello!")

def setup(bot):
    bot.add_cog(MyCommands(bot))
```

## Technology Stack

- **Framework:** FastAPI
- **Discord Library:** py-cord
- **Database:** PostgreSQL (via Supabase)
- **ORM:** SQLAlchemy 2.0
- **Migrations:** Alembic
- **Authentication:** python-jose + passlib
- **Process Manager:** PM2 (production)

## Related Components

- **Frontend:** `../frontend/` - Web dashboard
- **Screenshotter:** `../screenshotter/` - Automated reporting

## License

MIT
