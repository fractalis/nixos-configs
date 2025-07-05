# NixOS Configurations

## 💡 Inspiration

This repo is heavily inspired by the setup that [Haseeb Majid](https://haseebmajid.dev/) set up in his [Nixicle](https://github.com/hmajid2301/nixicle) setup.

## 📑 Usage

```bash

git clone git@github.com:fractalis/nixos-configs.git ~/infinitas/
cd infinitas

nix develop

# To build system configuration
nh os switch

# TO build user configuration
nh home switch

# Build ISO
nix build .#aeternus
```