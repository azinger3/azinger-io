# Cloudflare WAF with Pulumi

This project prepares a Python Pulumi stack for the zone-level custom WAF
ruleset. It does not create or modify any Cloudflare resources until you
import your existing ruleset and explicitly apply an update.

The existing dashboard ruleset is the source of truth for the initial import.
It may contain other rules, actions, priorities, and settings not documented
in the repository. Import the entire ruleset and preserve all of them.
Pulumi manages the whole ruleset, not just the landing-page rule.

## Setup

Run commands in this directory, `landing/iac/cloudflare`.

1. Install Pulumi with `brew install pulumi` if needed. Create the virtual
   environment and install the project dependencies:

   ```sh
   python3 -m venv .venv
   .venv/bin/python -m pip install -r requirements.txt
   ```

2. Create a Cloudflare API token scoped to your zone with **Zone WAF Write**
   permission. Keep the token out of files and shell history; enter it when
   prompted in your current shell:

   ```sh
   read -rs 'CLOUDFLARE_API_TOKEN?Cloudflare API token: '; echo
   export CLOUDFLARE_API_TOKEN
   ```

   The prompt syntax above is for zsh, the macOS default. In bash use
   `read -rs -p 'Cloudflare API token: ' CLOUDFLARE_API_TOKEN; echo`
   followed by `export CLOUDFLARE_API_TOKEN`.

3. Use a private local state backend and create a stack:

   ```sh
   mkdir -m 700 .state
   pulumi login "file://$PWD/.state"
   pulumi stack init production
   ```

   Set a strong passphrase when prompted and back it up separately. Back up
   `.state/` and `Pulumi.production.yaml` together: the state records resource
   ownership, and the stack file contains secrets-provider configuration.
   The passphrase and API token must also be kept safe. State and configuration
   may contain sensitive details even when secrets are encrypted.

## Import existing rules

1. Find your zone ID and the **ruleset ID** for the zone's
   `http_request_firewall_custom` phase. The ruleset ID is not an individual
   rule ID. For example, retrieve the entry point with Cloudflare's
   [Get an account or zone entry point ruleset API](https://developers.cloudflare.com/api/resources/rulesets/subresources/phases/methods/get/).
   Review its `result.id`, `result.rules`, and ordering. Never paste your API
   token into the repository.
2. Substitute the placeholders below. The bootstrap variable is for the
   import only; it allows the otherwise guarded empty program to run:

   ```sh
   CLOUDFLARE_IMPORT_BOOTSTRAP=1 pulumi import \
     'cloudflare:index/ruleset:Ruleset' custom-waf \
     'zones/<ZONE_ID>/<RULESET_ID>' --out managed_ruleset.py
   ```

   Review the preview before confirming. The import records the existing
   resource in Pulumi state and generates a Python resource declaration in
   `managed_ruleset.py`; it does not intentionally change the rules. Imported
   resources are protected against deletion by default. If the import fails,
   do not run `pulumi up`; investigate first.
3. Review the generated file for sensitive information and confirm it describes
   **every** existing rule in the same order, including actions and settings.
   This file is ignored by Git because the imported configuration may contain
   private details. Back it up alongside `.state/`.
4. Run `pulumi preview --diff` **without** the bootstrap variable. It should
   show no changes. If it proposes changes or a deletion, stop and reconcile
   the generated declaration with the live ruleset before continuing. Never
   run `pulumi up` with `CLOUDFLARE_IMPORT_BOOTSTRAP=1`: the empty program
   could otherwise propose removing managed resources.

## Maintain the landing-page rule

`waf_paths.py` contains the exact and substring matches from the expression
currently documented in the root README. After a successful, no-change import:

1. In `managed_ruleset.py`, add `from waf_paths import build_expression`, then
   replace **only** the landing-page rule's generated `expression` value with
   `build_expression()`. Leave the other rules, their order, and all other
   properties intact.
2. Run `pulumi preview --diff`. The generated expression is logically equivalent
   to the documented rule, but its formatting differs. Compare it with the
   actual live rule: the dashboard may have changed since the README was
   written. Do not apply unexpected changes.
3. Run `pulumi up` only after reviewing the diff. Then make future path edits in
   `waf_paths.py`, preview, and apply. The Free plan limits custom rules and
   each expression to 4,096 characters; the builder checks the length.

The local managed declaration is ignored until reviewed. If you want it in Git,
remove sensitive information first, then deliberately add it with
`git add -f landing/iac/cloudflare/managed_ruleset.py`. Never commit tokens, stack files,
state, backups, or generated files containing secrets.

Run `python3 -m unittest discover -s landing/iac/cloudflare` from the repository root
to check that the path lists match the documented rule.
