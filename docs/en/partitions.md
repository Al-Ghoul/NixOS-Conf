# Managing Partitions
Managing/Mounting other partitions is easier than ever with NixOS, mount your drive at `/mnt/{DRIVE_NAME}` -- replace drive name with your chosen name.
then run `nixos-generate-config --root /mnt` this will generate a `hardware-configuration.nix` file at `/mnt` directory, 
copy the new drives configurations to your original `hardware-configuration.nix`.
Check this commit for clarification [Commit's Diff](https://github.com/Al-Ghoul/NixOS-Conf/commit/f9fe269005b0ce064a0af60ad715310c485a9667#diff-a8a5dc4d98dca155b4d66f435f89f3f8046c400979b5f2e6a8a6475d7e74c205)

Example:
running `lsblk` on my machine outputs the following:
```bash
# Other partitions
sdb1    8:17   0 232.9G  0 part 
└─sdb   8:16   0 232.9G  0 disk 
# Other partitions
```

I'll focus on this particular partition `sdb1` which is a hard drive of 232GB size, mounting the drive at `/mnt/HardDriveTwo` with the following
```bash
sudo mount /dev/sdb1 /mnt/HardDriveTwo
```
yields the following error (if you did NOT experience this error skip this step [Adding new configration](#generating-and-adding-the-new-configurations)):
```bash
mount: /mnt/HardDriveTwo: unknown filesystem type 'ntfs'.
       dmesg(1) may have more information after failed mount system call.
```
This is because the Hard drive's format is in ntfs (Used by windows OS) we've to pass `nfts3` as a type flag
```bash
sudo mount /dev/sdb1 /mnt/HardDriveTwo -t ntfs3
```
This should mount the drive at `/mnt/HardDriveTwo`.

## Generating and adding the new configurations
you can now run `nixos-generate-config --root /mnt` and that'll yield a `hardware-configuration.nix` at `/mnt`, 
simply copy the extra configration for the new mounted/presented drives and add them to your original `hardware-configuration.nix` then delete the one at `/mnt`.
