## installation steps

- Install required packages:
    - sshpass
    - python-passlib
- Copy `inventory.example.yml` to `inventory.yml`, modifying fields as adequate.
- Look at `group_vars/all/vars.yml`, and set needed settings in `host_vars/<hostname>/vars.yml`, or `group_vars/all/overlay.yml`.
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
    ansible-vault create group_vars/all/vault.yml
    ansible-vault edit group_vars/all/vault.yml
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

- Start avahi-daemon (install `avahi` if not installed):
    ```
    systemctl start avahi-daemon
    ```
- Run the playbook:
    ```
    ansible-playbook run.yml --ask-vault-pass
    ```
