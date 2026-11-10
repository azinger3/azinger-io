# azinger-io
Personal Monorepo

# New Apps
`rails new {app_name} --skip-git`

# New Api

# New Page

# Landing
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

## Cloudflare Security Rule Maintenance
Scanners constantly probe for leaked files (`.git`, `.env`, keys, backups, WordPress paths). Blocking them at Cloudflare's edge keeps them off the tunnel and out of the Rails log.

Dashboard: **Security → WAF → Custom rules → Create rule → Edit expression**, action **Block**.

The Free plan doesn't allow the `matches` (regex) operator or `ends_with`, so the rule uses only `contains` and `in`:

```
(http.request.uri.path contains "/.git") or
(http.request.uri.path contains "/.aws") or
(http.request.uri.path contains "/.ssh") or
(http.request.uri.path contains "/.kube") or
(http.request.uri.path contains "/.docker") or
(http.request.uri.path contains "/.github") or
(http.request.uri.path contains "/.env") or
(http.request.uri.path in {"/.npmrc" "/.netrc" "/_netrc" "/.pypirc" "/.s3cfg" "/.boto" "/.dockercfg" "/.htaccess" "/.htpasswd" "/.gitignore" "/.gitmodules" "/.travis.yml" "/.gitlab-ci.yml" "/.drone.yml" "/Jenkinsfile" "/Dockerfile" "/docker-compose.yml" "/docker-compose.yaml" "/package.json" "/webpack.config.js" "/kubeconfig" "/id_rsa" "/id_rsa.pub" "/id_dsa" "/.dev.vars" "/.firebaserc" "/.amplifyrc" "/.zshrc" "/.bashrc" "/rclone.conf" "/sitemap.xml" "/sitemap_index.xml" "/llms.txt"}) or
(http.request.uri.path in {"/account" "/billing" "/auth" "/console" "/login" "/invite" "/organization" "/integrations" "/webhooks" "/onboarding" "/debug" "/playground" "/pricing" "/checkout" "/internal"}) or
(http.request.uri.path contains "/proc/") or
(http.request.uri.path contains "tfstate") or
(http.request.uri.path contains "debug") or
(http.request.uri.path contains "/wp-") or
(http.request.uri.path contains "/wordpress") or
(http.request.uri.path contains "xmlrpc") or
(http.request.uri.path contains "/actuator") or
(http.request.uri.path contains "/administrator") or
(http.request.uri.path contains "/phpmyadmin") or
(http.request.uri.path contains "credentials") or
(http.request.uri.path contains "service-account") or
(http.request.uri.path contains "service_account") or
(http.request.uri.path contains "adminsdk") or
(http.request.uri.path contains "/backup") or
(http.request.uri.path contains "/dump") or
(http.request.uri.path contains ".sql") or
(http.request.uri.path contains ".bak") or
(http.request.uri.path contains ".zip") or
(http.request.uri.path contains ".tar") or
(http.request.uri.path contains ".tgz") or
(http.request.uri.path contains ".pem") or
(http.request.uri.path contains ".key") or
(http.request.uri.path contains ".php") or
(http.request.uri.path contains ".json") or
(http.request.uri.path contains ".toml") or
(http.request.uri.path contains ".yml") or
(http.request.uri.path contains ".yaml") or
(http.request.uri.path contains ".map") or
(http.request.uri.path contains ".log") or
(http.request.uri.path contains "/cgi-bin") or
(http.request.uri.path contains "/_next") or
(http.request.uri.path contains "/storage") or
(http.request.uri.path contains "/bootstrap") or
(http.request.uri.path contains "/artisan") or
(http.request.uri.path contains "/graphql") or
(http.request.uri.path contains "/swagger") or
(http.request.uri.path contains "/openapi") or
(http.request.uri.path contains "/api") or
(http.request.uri.path contains "/config") or
(http.request.uri.path contains "/settings") or
(http.request.uri.path contains "/secrets") or
(http.request.uri.path contains "/env") or
(http.request.uri.path contains "/admin") or
(http.request.uri.path contains "/dashboard") or
(http.request.uri.path contains "/.vercel") or
(http.request.uri.path contains "/.serverless") or
(http.request.uri.path contains "/.langchain") or
(http.request.uri.path contains "/.huggingface")
```

This is safe for a static landing page. Revisit it if the site ever serves paths containing these strings (for example a `/backup` page, `.zip` downloads, a `/login` or `/pricing` page, or a `/sitemap.xml` you want search engines to read).

Verify with `curl -I https://example.com/.git/config` (expect 403) and `curl -I https://example.com/` (expect 200). Blocked requests show up under **Security → Events**.

## Notes
- `example.com` must be in `config.hosts` in `landing/config/environments/production.rb`.
- A `connection refused` error on `localhost:3000` in the tunnel log means the Rails server isn't running.
- To run the tunnel in the background and at login: `brew services start cloudflared`.