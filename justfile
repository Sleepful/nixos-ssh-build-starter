NAME := "nix" # UPDATE THIS TO THE SSH PROFILE OF TARGET MACHINE

delete:
	ssh {{NAME}} "rm -rf /etc/nixos/*"

copy:
	rsync -av --include='src/' --include='*.nix' --exclude='*' --exclude='.git/*' . root@{{NAME}}:/etc/nixos

sync: delete copy

build:
	ssh {{NAME}} "time nixos-rebuild switch"

SOPS_KEY := "~/.ssh/id_ed25519_my_custom_private_key" # UPDATE THIS FOR DECRYPTING ONLY (explained in ./Secrets.md)
secret filename:
	SOPS_AGE_SSH_PRIVATE_KEY_FILE={{SOPS_KEY}} sops {{filename}}
