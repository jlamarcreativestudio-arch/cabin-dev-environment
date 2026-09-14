# Extension Points

The base template intentionally stops at checks and documentation. Future
runtime integrations should attach to named locations without making the base
environment dependent on one provider or model family.

## Reserved locations

| Future concern | Suggested location | Initial state |
| --- | --- | --- |
| MLX | `docs/extensions/mlx.md`, `scripts/extensions/mlx.sh` | Document and verify only when approved. |
| Qwen | `docs/extensions/qwen.md`, `scripts/extensions/qwen.sh` | Document and verify only when approved. |
| llama.cpp | `docs/extensions/llama-cpp.md`, `scripts/extensions/llama-cpp.sh` | Document and verify only when approved. |
| OpenClaw | `docs/extensions/openclaw.md`, `scripts/extensions/openclaw.sh` | The base bootstrap only detects `openclaw`. |
| Claude | `docs/extensions/claude.md`, `scripts/extensions/claude.sh` | The base bootstrap only detects `claude`. |
| Codex | `docs/extensions/codex.md`, `scripts/extensions/codex.sh` | The base bootstrap only detects `codex`. |
| MCP servers | `docs/extensions/mcp.md`, `scripts/extensions/mcp.sh` | No server is configured by default. |
| Router infrastructure | `docs/extensions/router.md`, `scripts/extensions/router.sh` | No endpoint or credential is assumed. |
| Agent orchestration | `docs/extensions/orchestration.md`, `scripts/extensions/orchestration.sh` | No agent is launched by default. |

These are conventions, not permission to add implementations. A future change
must define its trust boundary, inputs, outputs, credentials, failure behavior,
and verification evidence before adding code.

## Rules for additions

1. Keep provider and model integrations optional to the base environment.
2. Make installers versioned and explicit; do not silently download latest code.
3. Keep credentials outside Git and outside snapshots.
4. Add a dry-run or inspection mode before adding mutation.
5. Add a verification check that proves the intended local effect.
6. Document what remains unknown; tool presence is not provider qualification.
7. Keep task repositories and model weights out of this template unless a future
   decision explicitly changes the scope.
