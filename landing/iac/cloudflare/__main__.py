import os
from pathlib import Path

if Path(__file__).with_name("managed_ruleset.py").is_file():
    import managed_ruleset  # noqa: F401
elif os.environ.get("CLOUDFLARE_IMPORT_BOOTSTRAP") != "1":
    raise RuntimeError(
        "No imported Cloudflare ruleset found. Follow the import steps in "
        "landing/iac/cloudflare/README.md before running Pulumi."
    )
