# homeserver ansible playbook

This Ansible playbook allows me to set up and configure all my home lab servers completely automatically, with little to no intervention.
It is for personal use; do not rely on this for anything important.

Special thanks to [Wolfgang](https://github.com/notthebee/) for the idea of automating the installation process.
This project was largely inspired by his own [infra](https://github.com/notthebee/infra) repo.

## services

The following services are managed completely automatically:
- [Gitea](https://about.gitea.com/)
- [Matrix Synapse](https://github.com/matrix-org/synapse)
- [Syncthing](https://syncthing.net/)
- [Navidrome](https://www.navidrome.org/)
- [Paperless-ngx](https://docs.paperless-ngx.com/)
- [Exim](https://www.exim.org/) mail (internal use only)
- [Caddy](https://caddyserver.com/) reverse proxy

## misc features

- Firewall setup (UFW)
- Python bootstrapping
- Setting up static IP in LAN
- External storage decryption/mounting
- Dotfile installation

## usage

The playbook assumes fresh Arch Linux ARM images installed on machines in your LAN, connected via Ethernet.
They should start off with default credentials (i.e. `alarm:alarm`, `root:root`).
This repo takes care of everything else.
The intended topology is a bastion host facing the Internet, with reverse proxies forwarding traffic to a service host inside the firewall.

- Flash all your machines with Arch Linux ARM.
- Copy `inventory.example.yml` to `inventory.yml`.
- Write down the machines' DHCP addresses inside `inventory.yml` under the `fallback_host` field.
- Assign static LAN IP addresses for your machines in the inventory.
- Create ssh keys for all your hosts:
    ```
    mkdir -p ~/.ssh/keys
    ssh-keygen -t ed25519 -f ~/.ssh/keys/your_host_name
    ```
    It is important for the hostnames to match your inventory hostnames.

- Set up your domain name and networks.
    - Forward all needed ports to your bastion host's static IP.
    - Set up a dynamic DNS subdomain, for example via [nsupdate](https://www.nsupdate.info/).
    - Create subdomains for Gitea, Matrix, and Navidrome. These should be forwarded to your dynamic DNS subdomain via CNAME records. Configure these subdomains in `group_vars` (see below.)

- Install required packages:
    - sshpass
    - python-passlib
- Look at `group_vars/all/50-vars.yml`, and set needed settings in `host_vars/<hostname>/vars.yml`, or `group_vars/all/90-overlay.yml`.
    (Files in group vars with a larger number have more precedence.)
- Look at the following roles, and for each of them override their `defaults/vars.yml` in host or group vars:
    - `networking/connection`
    - `networking/nameserver`
    - `caddy`
    - `containers`
    - `filesystems`
    - `firewall`
    - `syncthing`
    - `website`
- Create vault for secrets:
    ```
    ansible-vault create group_vars/all/80-vault.yml
    ansible-vault edit group_vars/all/80-vault.yml
    ```
    Copy-paste `group_vars/all/00-secret_template.yml` into this vault,
    and modify as needed.

- Add secret files:

    ```
    # Keyfile for LUKS disk encryption
    dd if=/dev/random of=roles/filesystems/files/host1.secret bs=1024 count=2
    ansible-vault encrypt roles/filesystems/files/host1.secret
    # repeat the above for every host with encrypted external storage
    ```

- Run the playbook:
    ```
    ansible-playbook run.yml --ask-vault-pass
    ```
