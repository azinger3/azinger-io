"""Path matches for the existing landing-page WAF rule."""

import json

EXACT_PATHS = (
    "/.npmrc",
    "/.netrc",
    "/_netrc",
    "/.pypirc",
    "/.s3cfg",
    "/.boto",
    "/.dockercfg",
    "/.htaccess",
    "/.htpasswd",
    "/.gitignore",
    "/.gitmodules",
    "/.travis.yml",
    "/.gitlab-ci.yml",
    "/.drone.yml",
    "/Jenkinsfile",
    "/Dockerfile",
    "/docker-compose.yml",
    "/docker-compose.yaml",
    "/package.json",
    "/webpack.config.js",
    "/kubeconfig",
    "/id_rsa",
    "/id_rsa.pub",
    "/id_dsa",
    "/.dev.vars",
    "/.firebaserc",
    "/.amplifyrc",
    "/.zshrc",
    "/.bashrc",
    "/rclone.conf",
    "/sitemap.xml",
    "/sitemap_index.xml",
    "/llms.txt",
    "/account",
    "/billing",
    "/auth",
    "/console",
    "/login",
    "/invite",
    "/organization",
    "/integrations",
    "/webhooks",
    "/onboarding",
    "/debug",
    "/playground",
    "/pricing",
    "/checkout",
    "/internal",
    "/.svn/wc.db",
    "/app-props",
    "/app.py",
    "/application-dev.properties",
    "/aws-exports.js",
    "/aws/aws_credential_file",
    "/azure-config.js",
    "/azure-functions",
    "/azure.env",
    "/backend.py",
    "/index.js",
    "/info",
    "/next.config.js",
    "/phpinfo",
    "/scripts/azure/backend.env",
    "/server.js",
    "/server/app.py",
    "/src/llm/azure_openai.py",
    "/start.sh",
    "/test",
    "/vite.config.js",
    "/vite.config.ts",
    "/web.config",
)

PATH_SUBSTRINGS = (
    "/.git",
    "/.aws",
    "/.ssh",
    "/.kube",
    "/.docker",
    "/.github",
    "/.env",
    "/proc/",
    "tfstate",
    "debug",
    "/wp-",
    "/wordpress",
    "xmlrpc",
    "/actuator",
    "/administrator",
    "/phpmyadmin",
    "credentials",
    "service-account",
    "service_account",
    "adminsdk",
    "/backup",
    "/dump",
    ".sql",
    ".bak",
    ".zip",
    ".tar",
    ".tgz",
    ".pem",
    ".key",
    ".php",
    ".json",
    ".toml",
    ".yml",
    ".yaml",
    ".map",
    ".log",
    "/cgi-bin",
    "/_next",
    "/storage",
    "/bootstrap",
    "/artisan",
    "/graphql",
    "/swagger",
    "/openapi",
    "/api",
    "/config",
    "/settings",
    "/secrets",
    "/env",
    "/admin",
    "/dashboard",
    "/.vercel",
    "/.serverless",
    "/.langchain",
    "/.huggingface",
)


def build_expression() -> str:
    """Build the Cloudflare expression without changing path-match semantics."""

    if not EXACT_PATHS or not PATH_SUBSTRINGS:
        raise ValueError("Both WAF path lists must be nonempty.")

    exact = " ".join(json.dumps(path, ensure_ascii=True) for path in EXACT_PATHS)

    clauses = [f"(http.request.uri.path in {{{exact}}})"]

    clauses.extend(
        f"(http.request.uri.path contains {json.dumps(path, ensure_ascii=True)})"
        for path in PATH_SUBSTRINGS
    )

    expression = " or\n".join(clauses)

    if len(expression) > 4096:
        raise ValueError("Cloudflare WAF expressions cannot exceed 4,096 characters.")

    return expression
