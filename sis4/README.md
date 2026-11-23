# SIS4: Ansible

One playbook (`site.yml`) takes a plain Ubuntu 22.04 host to the state reached in SIS1-3,
then runs smoke tests for every role.

| Role | Source | What it does |
|------|--------|--------------|
| base | SIS3 | packages from apt, GitHub CLI apt repo, yq static binary |
| docker | - | Docker Engine and compose plugin |
| filesystem | SIS1 | service account, directory layout, app env file |
| users | SIS2 | role groups and users |
| permissions | SIS2 | ACLs and sudoers rules |
| ssh | SIS2 | automation key, sshd hardening |
| vikunja | SIS2 | compose stack (Vikunja + PostgreSQL) under systemd |
| caddy | SIS3 | reverse proxy with TLS |
| firewall | SIS3 | ufw, SSH allowed first |
| network | SIS3 | network map in /var/log/network-map.txt |

Each role has `tasks/test.yml` with its smoke tests. The second and third plays of
`site.yml` run them on the host and over the network (public ports open, internal closed).

## Run

```bash
python3 -m venv ~/.venvs/ansible && ~/.venvs/ansible/bin/pip install "ansible==10.*"
export PATH=~/.venvs/ansible/bin:$PATH
ansible-galaxy collection install -r requirements.yml

# clean test host (LXD container from the stock ubuntu:22.04 image)
bash test/create_test_vm.sh            # prints the IP, put it into inventory/test.ini
ansible-playbook site.yml              # full setup + tests
ansible-playbook site.yml --tags test  # tests only
bash test/destroy_test_vm.sh

# production VM
ansible-playbook -i inventory/prod.ini site.yml
```

Secrets (DB password, JWT secret) are generated on the control node in `credentials/`
on the first run and are not committed.
