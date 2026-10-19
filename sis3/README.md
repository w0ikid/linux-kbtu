# SIS3 — Installing packages

Prepare the environment: install required packages, document the network, set up
firewall rules and verify everything with a smoke test. Host: Oracle Cloud VM,
Ubuntu 22.04 LTS (ARM64); the app (Vikunja) runs in Docker behind Caddy.

## Scripts

| Script | Task |
|--------|------|
| `01_install.sh` | Install packages three ways: `htop` (default apt repo), `gh` (newly added apt repo), `yq` (static binary, no package manager) |
| `02_network.sh` | Dump interfaces, routes and listening ports |
| `03_firewall.sh` | Configure `ufw`: default deny incoming, allow only 22/80/443 (SSH first) |
| `04_smoke_test.sh` | Check ports, service, binaries and web response; non-zero exit on any failure |
| `run_all.sh` | Run 01, 02, 04 (03 is run manually — SSH lockout risk) |

## Usage

```bash
bash 01_install.sh
bash 02_network.sh
bash 03_firewall.sh    # run manually; allows SSH before enabling ufw
bash 04_smoke_test.sh
```

## Notes

- The VM is ARM64, so the `yq` binary is selected with
  `yq_linux_$(dpkg --print-architecture)`.
- Internal services (Vikunja 3456, Postgres 5432, Caddy admin 2019) stay bound to
  `127.0.0.1`; combined with `ufw` they are not reachable from outside.
- `03_firewall.sh` allows port 22 before enabling the firewall to avoid locking
  out the remote SSH session.
