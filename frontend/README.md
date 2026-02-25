# Blue Deer Trading Frontend

A Next.js 14 web application for viewing trades, portfolio analytics, and managing trade configurations.

## Features

- Real-time trade tracking via Supabase
- Portfolio statistics and P/L visualization
- Monthly trade performance charts
- Trade configuration management
- Support for multiple trader groups (Day Trader, Swing Trader, Long Term Trader)
- Options strategies tracking

## Prerequisites

- Node.js 18+
- npm or yarn
- Supabase account (with project transferred from previous owner)

## Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment Variables

```bash
cp .env.example .env.local
```

Edit `.env.local` with your Supabase credentials:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
```

**Where to find these values:**
- Supabase Dashboard → Project Settings → API
- `NEXT_PUBLIC_SUPABASE_URL`: Project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Project API Keys → anon public

### 3. Run Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
frontend/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── page.tsx           # Home page
│   │   ├── portfolio/         # Portfolio view page
│   │   ├── search/            # Trade search page
│   │   └── position-sizing/   # Position sizing calculator
│   ├── components/            # React components
│   │   ├── trades/           # Trade-related components
│   │   ├── portfolio/        # Portfolio components
│   │   └── ui/               # Reusable UI components (shadcn/ui)
│   ├── lib/                   # Utilities and types
│   │   ├── supabase.ts       # Supabase client
│   │   ├── database.types.ts # TypeScript types for DB
│   │   └── portfolio.ts      # Portfolio calculations
│   └── types/                # TypeScript type definitions
├── supabase/                  # Supabase configuration
│   ├── functions/            # Edge functions
│   └── migrations/           # Database migrations
├── public/                   # Static assets
└── package.json
```

## Key Components

### Trade Views

- **Open Trades**: Currently open positions by trader group
- **Portfolio View**: Realized trades and performance metrics
- **Options Strategies**: Options-specific trade tracking

### Data Flow

1. Frontend queries Supabase via edge functions
2. Edge functions return aggregated trade data
3. React components render trades and statistics
4. Charts display P/L trends using Recharts

## Available Scripts

```bash
# Development
npm run dev          # Start dev server with hot reload
npm run build        # Build for production
npm start            # Start production server
npm run lint         # Run ESLint

# Supabase (if using Supabase CLI)
npx supabase start   # Start local Supabase
npx supabase stop    # Stop local Supabase
```

## Deployment

### Vercel (Recommended)

1. Push code to GitHub
2. Go to [vercel.com](https://vercel.com)
3. Import your repository
4. Configure:
   - **Root Directory:** `frontend/`
   - **Framework Preset:** Next.js
5. Add Environment Variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
6. Deploy

**Note:** If you change the deployment URL, update the `SITE_URL` in the screenshotter GitHub Actions secrets.

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `NEXT_PUBLIC_SUPABASE_URL` | Your Supabase project URL | Yes |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon/public API key | Yes |

**Important:** All `NEXT_PUBLIC_` variables are exposed to the browser. Never put secrets here.

## Technology Stack

- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **UI Components:** shadcn/ui
- **Charts:** Recharts
- **Database:** Supabase (PostgreSQL)
- **Icons:** Lucide React

## Troubleshooting

### Build Errors

```bash
# Clear Next.js cache
rm -rf .next
npm run build
```

### Supabase Connection Issues

1. Verify credentials in `.env.local`
2. Check Supabase project is active (not paused)
3. Check browser console for CORS errors
4. Verify network connectivity to Supabase

### Missing Types

```bash
# Regenerate Supabase types (if schema changes)
npx supabase gen types typescript --project-id your-project-ref --schema public > src/lib/database.types.ts
```

## Security Notes

- Frontend has password protection (handled by screenshotter)
- Never commit `.env.local` to git
- Use Supabase Row Level Security (RLS) policies for data protection
- API calls go through Supabase edge functions for security

## Related Components

- **Discord Bot:** Located in `../discord_bot/`
- **Screenshotter:** Located in `../screenshotter/`

## License

MIT
