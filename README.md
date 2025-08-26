# modified caelestia quickshell config

# Steps 

these are the steps i took to install it and customize it

1. Install the dots

```bash 
git clone https://github.com/caelestia-dots/caelestia.git ~/.local/share/caelestia
~/.local/share/caelestia/install.fish
```

2. copy `foot`, `fish`, `nvim` and other configs in `~/.config/`

3. Copy `caelestia` in `~/.config/`

Run:

```bash 
killall qs 
qs -c caelestia -d
```

