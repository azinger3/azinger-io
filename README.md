# azinger-io
Personal Monorepo

# New Apps
`rails new {app_name} --skip-git`

# New Api


# New Page

# Hosting
The landing app is served from this machine and exposed at https://example.com through a Cloudflare Tunnel.

## Cloudflare Tunnel Setup
1. Install `cloudflared`:
   ```sh
   brew install cloudflare/cloudflare/cloudflared
   cloudflared --version
   ```
2. Log in to Cloudflare (opens a browser; saves `~/.cloudflared/cert.pem`):
   ```sh
   cloudflared tunnel login
   ```
3. Create the tunnel (writes credentials to `~/.cloudflared/<TUNNEL_ID>.json`; keep it secret):
   ```sh
   cloudflared tunnel create my-tunnel
   ```
4. Create `~/.cloudflared/config.yml` pointing at the Rails server:
   ```yaml
   tunnel: my-tunnel
   credentials-file: /Users/<your-user>/.cloudflared/<TUNNEL_ID>.json

   ingress:
     - hostname: example.com
       service: http://localhost:3000
     - service: http_status:404
   ```
5. Route DNS for the domain to the tunnel:
   ```sh
   cloudflared tunnel route dns my-tunnel example.com
   ```
6. Start the Rails app in production (from the repo root):
   ```sh
   RAILS_ENV=production ./start-landing.sh
   ```
7. Run the tunnel:
   ```sh
   cloudflared tunnel --config ~/.cloudflared/config.yml run my-tunnel
   ```

## Notes
- `example.com` must be in `config.hosts` in `landing/config/environments/production.rb`.
- A `connection refused` error on `localhost:3000` in the tunnel log means the Rails server isn't running.
- To run the tunnel in the background and at login: `brew services start cloudflared`.