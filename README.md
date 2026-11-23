# linux-kbtu

- `sis1/` filesystem layout for Vikunja
- `sis2/` roles, users, permissions, SSH, systemd unit (`run_all.sh <pubkey>`)
- `sis3/` package install, network map, ufw firewall, smoke test
- `sis4/` Ansible playbook that rebuilds everything from SIS1-3 on a plain Ubuntu 22.04 host, with smoke tests
