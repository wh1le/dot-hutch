#### Modify dot files

Create or rename a user to your username, update hardware requirements to match your machine.

Add this to your config at outputs.nixosConfigurations.yourHost

```nix

yourHost = import ./nixos/hosts/your_host.nix {
  inherit inputs nixpkgs nixpkgs-unstable self;
  extraModules = [
    {
      home-manager.extraSpecialArgs = { inherit self inputs; };
      home-manager.users.wh1le = ./nixos/home/users/your_user_name.nix;
      home-manager.backupFileExtension = "backup";
    }
  ];
};
```

Reuse existing config or create new files:

```bash
cp nixos/hosts/thinkpad.nix nixos/hosts/your_machine.nix
cp nixos/users/wh1le.nix nixos/hosts/username.nix
```

You can simply skip most of the steps but pay close attention to hardware modules to make sure your machine settings are matching. Right now hardware modules are under respectfull folders for my machines.
but I am planning to move them out to modules/hardware folder to unify configuration. Main thing you need to configure are videocards, processor, kernel boot params etc.

you can see examples at:

todo: link documentation

- radeon graphics card: nixos/homepc/videocards/radeon.nix
- nvidia graphics card: nixos/homepc/videocards/nvidia.nix
- if you think that your life is not yet hard like me and you running two gpus see: nixos/homepc/videocards/dual_gpu.nix
- for cpu and boot options seee: hardware/thinkpad/boot hardware/homepc/boot

```nix
{
...
# hardware
./modules/hardware/thinkpad/disko.nix
./modules/hardware/thinkpad/hardware-configuration.nix
./modules/hardware/thinkpad/disable-backlight.nix
./modules/hardware/thinkpad/boot-amd.nix
./modules/hardware/thinkpad/boot.nix
./modules/hardware/thinkpad/network.nix
./modules/hardware/thinkpad/keyboard.nix
./modules/hardware/thinkpad/power-management-balanced.nix
./modules/hardware/thinkpad/cooling.nix
./modules/hardware/thinkpad/audio.nix
./modules/hardware/printers.nix
./modules/hardware/bluetooth.nix
./modules/hardware/usb.nix
...
}
```

### Live USB installation

#### Clone repo

git clone --recurse-submodules https://github.com/wh1le/dot-hutch.git ~/dot/dot-hutch

I store my dot-files at ~/dot it is convention I came up with most of the scripts depend on that. Feel free to change it after installation and modify the path to your liking
but stick to this path during installation. If you change the path don't forget to relink your dot-files inside home configuration link home/modules/link-dot-files.

if you have problems with undefined constants in zsh post install run `git submodule update --init --recursive` inside dot-files.

#### format drives

You can manually format the drive or use disko:

Edit disko configuration to your liking nixos/hardware/thinkpad/disko.nix.
Map swap drive to match your ram size on your machine for hibernation. To see how much ram you have use `free -h`

After editing the file:

```bash
  sudo nix --experimental-features "nix-command flakes" \
	  run github:nix-community/disko -- --mode disko \
	  --flake "$HOME/dot/dot-hutch#your_hostname"
```

If you skip disko and do mapping yourself don't forget to mount partitions to /mnt{boot,home}

#### Setup sops

Sops can be overwhelming when starting using. You can read doc at https://github.com/Mic92/sops-nix.
You can configure it post install and use this script to autogenerate a private/public key and empty config with default values :

nix --extra-experimental-features "nix-command flakes" shell nixpkgs#age nixpkgs#sops --command $HOME/dot/dot-hutch/scripts/deploy-empty-sops.sh

it will create key and empty configuration for you.

Secrets:

```yml
openweathermap: # Is used for weather forecast for waybar get the key at https://openweathermap.org/
email: # your personal email
searx_secret_key: # search secret key, grab it from setting after install at localhost:8882
disroot:
  nextcloud: # I store my sensitive data encrypted (passwords, browser history, documents, recovery codes) you can skip this part and keep them either empty or set some default values
    user:
    password:
  rclone:
    password: # to generate rclone pass run: echo "password: $(rclone obscure "$(openssl rand -base64 32)")"
    salt: # same for salt echo "salt: $(rclone obscure "$(openssl rand -base64 32)")"
```

##### Install system

sudo nixos-install --flake "$HOME/dot/dot-hutch#yourhostname"

##### Relink config:

copy config from live usb to your installation:

mkdir -p /mnt/home/your_user/dot
cp -rf ~/dot/nix-hutch /mnt/home/your_user/dot/nix-hutch

link your installation to /mnt/etc/nixos

ln -sfn /mnt/home/your_user/dot/nix-hutch /mnt/etc/nixos

##### Set Password

login to installed version with

nixos-enter --root /mnt

passwd

and for your new user:

passwd your_user

##### Optional

##### BIOS Security Keys on NixOS with Lanzaboote

Enter bios and set password. Enable Secure Boot Setup mode and clear existing key.

After initial boot run:

```bash
sudo sbctl create-keys
```

Keys stored in `/var/lib/sbctl/`.

Check Secure Boot Status

```bash
sudo sbctl status
```

Enroll Keys in Firmware

```bash
sudo sbctl enroll-keys --microsoft
```

`--microsoft` includes MS keys for dual-boot/firmware compatibility. Omit for strict security but be very carefull that you can brick your machine. It is the case for some thinkpads

Verify Signed Files

```bash
sudo sbctl verify
```

Rebuild and Reboot

```bash
sudo nixos-rebuild switch --flake ~/dot/nix-hutch#yourhostname
```

```bash
reboot
```

Enable Secure Boot in BIOS after reboot.

BIOS/UEFI Passwords

Set in BIOS setup (F1/F2/Del at boot):

- **Supervisor password** — locks BIOS settings
- **Power-on password** — required to boot
- **HDD password** — firmware-level drive encryption

Backup Keys

```bash
sudo cp -r /var/lib/sbctl ~/backup/sbctl-$(date +%Y%m%d)
```

Store offline and encrypted.
