NAME := "nix"

delete:
	ssh {{NAME}} "rm -rf /etc/nixos/*"

copy:
	rsync -av --include='src/' --include='*.nix' --exclude='*' --exclude='.git/*' . root@{{NAME}}:/etc/nixos

sync: delete copy

build:
	ssh {{NAME}} "time nixos-rebuild switch"
