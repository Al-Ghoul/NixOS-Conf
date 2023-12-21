للعربية إضغط علي الرابط التالي: [التوثيق](docs/ar/README.md)

# Intro
This is my NixOS's Configuration files, I'll update it as I'm learning more'bout Nix/NixOS.

## Managing the Configuration with Git
NixOS configuration, being a set of text files, is well-suited for version control with Git.
This allows easy rollback to a previous version in case of issues.

By default, NixOS places the configuration in `/etc/nixos/`, which requires root permissions for modification (Requires to run stuff with sudo/root i.e `sudo vim /etc/nixos`),
making it inconvenient for daily use. Thankfully, Flakes can help solve this problem by allowing you to place your flake anywhere you prefer.

For example, I place my repos in `/home/$USER/repos` directory, and create a symbolic link in `/etc/nixos` as follows:
```bash
sudo mv /etc/nixos /etc/nixos.bak # Backup your current configuration
sudo ls -s /home/alghoul/repos/NixOS-Conf /etc/nixos # TODO: REPLACE alghoul with your username

# Deploy the flake.nix located at the default location (/etc/nixos) which is just a sym link to /home/$USER/repos/NixOS-Conf
sudo nixos-rebuild switch
```

## Other Partitions
To add other paritions that are not detected/auto mounted by default, please refer to the relative docs [Managing Partitions](/docs/en/partitions.md).
