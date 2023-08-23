## installation steps

- Copy `inventory.example.yml` to `inventory.yml`, modifying fields as adequate.
- Look at `group_vars/all/vars.yml`, and set needed settings in `host_vars/<hostname>/vars.yml`.
- Look at the following roles, and for each of them override their `defaults/vars.yml` in host or group vars:
    - `networking/connection`
    - `networking/ddclient`
    - `networking/nameserver`
    - `filesystems`
    - `firewall`
- Create vault for secrets:
    ```
    ansible-vault create host_vars/[hostname]/vault.yml
    ansible-vault edit host_vars/[hostname]/vault.yml
    ```
    Copy-paste `group_vars/all/secret_template.yml` into this vault,
    and modify as needed.

- Add secret files:

    ```
    # Keyfile for LUKS disk encryption
    dd if=/dev/random of=roles/filesystems/files/host1.secret bs=1024 count=2
    ansible-vault encrypt roles/filesystems/files/host1.secret
    # repeat the above for every host with encrypted external storage
    ```
