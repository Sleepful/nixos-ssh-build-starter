# Nixos in hetzner

Start server with any linux distro.
Then go to ISOs and mount Nixos ISO.
Open the console and follow the instructions here, starting from Partitioning UEFI.

> To do this process through ssh, make sure to set a password for the user, such as `sudo passwd` in the hetzner console, then ssh will be available.
> Ssh is recommended, as the web console might not accept certain key combinations.

> Hint: to delete the fingerprint from `knownhosts` in case ssh complains:
> `ssh-keygen -R <ip>`, this might be necessary each time the ssh agent connects to a different version of the server (e.g. with and without ISO mounted)

> hint: check with `efibootmgr` to see if server is efi. "EFI variables are not supported on this system." means it is not UEFI, and you can skip all UEFI instructions in the manual
https://nixos.org/manual/nixos/stable/#sec-installation-manual

When editing the `configuration.nix`, make sure to turn on what you need to login to the server once it is ready. 

For instance, add vim
```
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

```
And allow ssh with password for root user, which you might want to disable later on
```
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
```


After installation is complete and a password is set for the new nixos, "Power Off" the server from the Hetzner console, unmount the ISO, and Power On the machine again. Now you may login to a fresh install of NixOS.

Finally, facilitate your own `ssh` by copying your pub keys to the server, something like `ssh-copy-id user@<ip>`, entering password, and now future `ssh` won't need password. Don't forget to alias the host ip on `vim ~/.ssh/config`

