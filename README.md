# Proxsign (for Linux using Nix)

This repository contains a Nix flake for the proXSign signing component required for some Slovenian national infrastructure.

## Installation

First [install Nix](https://zero-to-nix.com/start/install) if you haven't already.

### Run without installing

    $ nix run github:amadejkastelic/proxsign-nix

### Install with nix profile

    $ nix profile install --impure github:amadejkastelic/proxsign-nix

### Installing on NixOS

#### With flakes

Add to your `flake.nix` inputs:

```nix
inputs.proxsign.url = "github:amadejkastelic/proxsign-nix";
```

Then in your NixOS configuration:

```nix
environment.systemPackages = [
  inputs.proxsign.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

#### Without flakes

Add to your `configuration.nix`:

```nix
environment.systemPackages = [
  (builtins.getFlake "github:amadejkastelic/proxsign-nix").packages.x86_64-linux.default
];
```

## Usage

### 1. Run the application

    $ proxsign

You should see GUI application display a list of your certificates (sigenca, etc).

### 2. Whitelist self-signed certificate in your browser

Chromium:

- Open https://localhost:14972/
- You should see "Your connection is not private"
- Click "Advanced"
- Click "Proceed to localhost (unsafe)"
- You will get an `404` error, which is fine

Firefox:

- Open https://localhost:14972/
- Add an exception for certificate
- You will get an `404` error, which is fine

### 3. Verify that everything works

- Open http://www.si-ca.si/podpisna_komponenta/g2/Testiranje_podpisovanja_IEFF_adv_g2.php
- Click "Podpisi"
- Click "Vredu"
- Click "Preveri podpis"
