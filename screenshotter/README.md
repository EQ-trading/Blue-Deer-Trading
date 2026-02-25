# Screenshotter

Automated screenshot tool that captures portfolio and trade views from the Blue Deer Trading frontend and posts them to Discord.

## Overview

This tool runs via GitHub Actions on a daily schedule (5 PM EST) to:
1. Navigate to the trading dashboard
2. Log in with the site password
3. Capture screenshots of all trade groups and views
4. Send organized screenshots to Discord webhooks

## How It Works

1. **Selenium WebDriver** controls a headless Firefox browser
2. **Screenshots are taken** of various trade views:
   - Day Trader, Swing Trader, Long Term Trader open trades
   - Options strategies for each group
   - Portfolio views for each group
3. **Discord Integration** sends screenshots to designated channels
4. **GitHub Actions** orchestrates the entire process on a schedule

## Prerequisites

- GitHub repository access
- Firefox and Geckodriver (automatically installed in GitHub Actions)
- Site URL and password
- Discord webhook URLs

## Local Development

### Setup

```bash
cd screenshotter

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Configure Environment

```bash
cp .env.example .env
```

Edit `.env`:

```env
# Required
SITE_URL=https://your-site-url.vercel.app
SITE_PASSWORD=your-site-password

# Optional - only if using custom webhooks
# DISCORD_WEBHOOK_DAY_TRADER=...
# DISCORD_WEBHOOK_SWING_TRADER=...
# etc.
```

### Run Locally

**Note:** This requires Firefox and Geckodriver to be installed on your system.

**macOS:**
```bash
brew install geckodriver
python screenshotter.py
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install firefox-geckodriver
python screenshotter.py
```

**Windows:**
1. Download Geckodriver from https://github.com/mozilla/geckodriver/releases
2. Add to PATH
3. `python screenshotter.py`

### Expected Output

The script creates a `screenshots/` directory with:
- `day_trader_trades.png`
- `day_trader_options_strategies.png`
- `day_trader_portfolio.png`
- (Similar for swing_trader and long_term_trader)
- `all_groups_trades.png`
- `all_groups_options_strategies.png`
- `all_groups_portfolio.png`

Screenshots are automatically sent to Discord.

## GitHub Actions Deployment

This is the primary way the screenshotter runs in production.

### Setup Steps

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add:

#### Required Secrets:

```
SITE_URL=https://your-frontend-url.vercel.app
SITE_PASSWORD=bluedeer
```

#### Optional Secrets (if you want to override default webhooks):

```
DISCORD_WEBHOOK_DAY_TRADER
DISCORD_WEBHOOK_SWING_TRADER
DISCORD_WEBHOOK_LONG_TERM_TRADER
DISCORD_WEBHOOK_FULL_PORTFOLIO
DEBUG_WEBHOOK_DAY_TRADER
DEBUG_WEBHOOK_SWING_TRADER
DEBUG_WEBHOOK_LONG_TERM_TRADER
DEBUG_WEBHOOK_FULL_PORTFOLIO
```

**Note:** If not provided, the screenshotter uses the hardcoded webhook URLs.

### Workflow Configuration

The workflow file is at `.github/workflows/screenshotter.yml`.

**Schedule:** Runs daily at 5 PM EST (10 PM UTC)
```yaml
cron: '0 22 * * *'
```

**Manual Trigger:** You can also run it manually:
1. Go to **Actions** → **Daily Screenshotter**
2. Click **Run workflow**
3. Select branch and click **Run workflow**

### What the Action Does

1. Sets up Ubuntu runner
2. Installs Firefox browser
3. Installs Geckodriver
4. Installs Python 3.12
5. Installs dependencies (selenium, requests, pyvirtualdisplay, python-dotenv)
6. Installs Xvfb (virtual display for headless mode)
7. Runs the screenshotter script
8. Uploads debug screenshots on failure (artifacts available for 7 days)

### Monitoring

**Check runs:**
- Go to **Actions** → **Daily Screenshotter**
- View run history and logs

**Debug failures:**
- Failed runs upload screenshots as artifacts
- Download artifacts from the run page
- Check Discord if partial screenshots were sent

## Configuration

### Changing the Schedule

Edit `.github/workflows/screenshotter.yml`:

```yaml
on:
  schedule:
    - cron: '0 22 * * *'  # 5 PM EST / 10 PM UTC
```

Use [crontab.guru](https://crontab.guru) to generate custom schedules.

### Adding New Trader Groups

1. Edit `screenshotter.py`
2. Update `DISCORD_FILE_GROUPS` dictionary
3. Add corresponding webhook URLs
4. Update `capture_all_trade_views()` or `capture_portfolio_for_all_groups()` functions

### Changing Screenshot Order

Modify `DISCORD_FILE_ORDER` list in `screenshotter.py`.

## Code Structure

```
screenshotter/
├── screenshotter.py       # Main script
├── requirements.txt       # Python dependencies
├── .env.example          # Environment template
├── run_screenshotter.sh  # Local run script (optional)
└── screenshots/          # Output directory (created at runtime)
```

## Key Functions

- **`setup_driver()`** - Configures Firefox WebDriver for macOS or Linux
- **`capture_all_trade_views()`** - Captures all trade and options views
- **`capture_portfolio_for_all_groups()`** - Captures portfolio screenshots
- **`handle_login()`** - Handles site password authentication
- **`send_screenshot_to_discord()`** - Sends organized screenshots to Discord

## Troubleshooting

### Script hangs on login

- Check `SITE_URL` is correct and accessible
- Verify `SITE_PASSWORD` matches the frontend password
- Check if frontend is deployed and running

### Screenshots are blank/cut off

- Increase wait times in the script (`time.sleep()`)
- Check if elements are present on the page
- Review debug screenshots in GitHub artifacts

### Discord messages not sending

- Verify webhook URLs are valid
- Check webhook hasn't been deleted in Discord
- Test webhook manually with curl:
  ```bash
  curl -X POST -H "Content-Type: application/json" \
    -d '{"content":"Test message"}' \
    YOUR_WEBHOOK_URL
  ```

### GitHub Actions failing

1. Check Actions logs for specific errors
2. Verify all secrets are set correctly
3. Download debug artifacts for screenshot review
4. Test locally with same environment variables

## Dependencies

| Package | Purpose |
|---------|---------|
| selenium | Browser automation |
| requests | Discord webhook HTTP calls |
| pyvirtualdisplay | Headless display on Linux |
| python-dotenv | Environment variable loading |

## Related Components

- **Frontend:** `../frontend/` - The site being screenshotted
- **Discord Bot:** `../discord_bot/` - Receives the screenshots

## License

MIT
