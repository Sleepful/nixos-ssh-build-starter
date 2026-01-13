# Encrypting secrets

This can be done with `agenix` on the local machine where one is writing the nixos config.

However, given that my local system is not NixOs, I decided to use `age` to create the encrypted files.

> If you prefer to use `agenix`, go ahead, creating secrets is explained clearly on the manual.
> The target NixOs system still uses `agenix` to decrypt the secrets.

## Encrypting with `age`

Make sure `age` is installed and:

```
age -r "ssh-ed25519 PUB-KEY" -o secret.age plaintext.txt
```

Here, the target machine that will run the configuration (therefore decrypt the secrets), needs to have the private counter-part to PUB-KEY.

### Avoiding the temporary file

Use [`sops`](https://github.com/getsops/sops) to open a file in the terminal with your `$EDITOR` without writing it to disk, and only creating the encrypted version:

```
sops secret.age
```

> Sops must be configured through `./.sops.yaml` 

This is what `.sops.yaml` might look like:

```yaml
creation_rules:
    # for public keys
    - age: ssh-ed25519 AAA...
    # or if native age keys are preferred (age-keygen)
    - age: age123...
```

## Decrypting

Decrypting is convenient, although not necessary. You can always delete the encrypted files and create new ones if you lose the secrets. If decrypting is desired:

### Justfile command

For convenience, the `secret` command is included in the `justfile`. Refer to the `justfile` to look at how it works. Use like so:

```sh
# create a secret with key from `.sops.yaml`:
just secret secret.age
# the same command can be used to decrypt, as long as SOPS_KEY is properly set in the `justfile`
```

### Plain `sops`

With a private ssh key, use the env var to specify its path:
```sh
SOPS_AGE_SSH_PRIVATE_KEY_FILE=~/.ssh/id_ed25519_my_custom_key sops secret.age
# defaults to ~/.ssh/id_ed25519 and ~/.ssh/id_rsa
```

Or with a native age key, use `SOPS_AGE_KEY` env var. More info in the [official docs](https://github.com/getsops/sops?tab=readme-ov-file#23encrypting-using-age).

# Backup up the keys that can decrypt the secrets

Remember, if local machine (L) is creating the secrets for remote machine (R), it means that:

- (L) must hold the public key from (R) to create encrypted secrets

However, in the case that (R) machine is lost, the (L) machine would not be able to decrypt the secrets and thus the secrets would be lost. This means that:

- The private key from (R) needs to be backed up outside of the (R) machine to recover the decrypted secrets from a backup.


