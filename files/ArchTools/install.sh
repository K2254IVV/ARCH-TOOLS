#!/bin/bash
script_url=$(curl -fsSL "https://raw.githubusercontent.com/K2254IVV/ARCH-TOOLS/refs/heads/main/files/ArchTools/lastest" | tr -d '[:space:]')
sh -c "$(curl -fsSL "$script_url")"
