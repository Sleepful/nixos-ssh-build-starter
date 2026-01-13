# Setting up NixOs in Hetzner

Look in [Hetzner.md](./Hetzner.md)

# Setting up NixOs in a Proxmox VM

Assuming that there is already access to a Proxmox instance, ideally in a LAN for low latencies.

- Download ISO to Proxmox VM collection, easy to do by using the official NixOs URL from the official site and entering this URL in Proxmox GUI.
- Launch the VM.
- Find the ip of the VM by opening the terminal from the GUI and using `ifconfig`.
- Add a temporary password in console with `sudo passwd`
- Now on your local machine, save the ip as an alias in `~/.ssh/config`
```
Host nix
  Port 22
  User root
  HostName <ip>
```
- Now you can ssh into `root@nix` and use the password.
- Now you can paste your public key:

```
echo "your pub key" > /root/.ssh/authorized_keys
```
- And finally you can delete the temporary password
`sudo passwd -d root`


- Now we can write the config on our machine and copy it into ssh.

The initial config is just this:

`/etc/nixos/configuration.nix`:
```
{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal-combined.nix> ];
}
```

By cloning this repo locally and using the commands in the [justfile](https://github.com/casey/just), easily write the config on your local machine and copy it over to the NixOs Proxmox.

You can confirm that the configuration has been applied just by running `tree`, if `tree` command is found, that means configuartion was successful.

> Note: in the `justfile` the `NAME := "nix"` determines the `ssh` profile that is used, make sure that it matches your configuration and update it if needed.

# Workflow

The goal of this workflow is to iterate on a NixOs config that will  be deployed to a remote VPC.

- Edit config locally from any operating system.
- Use `just sync` to copy config over to local NixOs system (hosted on LAN, could be within Proxmox or just a plain installation).
- Use `just build` to compile the new config on the local NixOs system.
- Test the local NixOs to make sure the config has been successful.
- Once it is successful locally, repeat the steps for remote NixOs in a VPC (hetzner or otherwise). 
  - Why build it twice? Well, one could go straight for the remote VPC, but I prefer going for local first to avoid the `ssh` latency while iterating on the config.
  - Alternatively if the remote machine does not have the resources to handle `nixos-rebuild switch`, one could upload the finished build from local NixOs to remote NixOs with `nix-copy-closure` (run from the local) + `"$SERVER_PROFILE/bin/switch-to-configuration switch"` (run from the remote). These commands are complex and reading the manual is going to be a requisite to use them properly.

# Secrets

Secrets in NixOs are a bit tricky: You want to create encrypted secrets when writing the configuration, but the secrets must be decrypted when the target NixOs machine runs the configuration.

Look in [Secrets.md](./Secrets.md)
