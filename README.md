# AuRCH

```text
    ___         ____  ________  __
   /   | __  __/ __ \/ ____/ / / /
  / /| |/ / / / /_/ / /   / /_/ /
 / ___ / /_/ / _, _/ /___/ __  /
/_/  |_\__,_/_/ |_|\____/_/ /_/
```

An opinionated Arch Linux derivative aimed at being the least bloated possible
while providing a beautiful interface and high usability for the slightly over
the average Windows-to-Linux user.

## Info

With a ~8 GBs base installation, `AuRCH` is a random project I made to help
my friends to switch to Linux without resorting to overly complex or
unnecessarily bloated distros.

While being plug & play, users will have a nice, fully functioning general
purpose system and derive it by installing the software they need.

A small amount of expertise in using computers is still needed. However, I
plan to include some form of manuals for first time Linux/tiling wm users.

## Usage

After completing an installation with `archinstall`, follow one of these
guides.

### Single line

Copy-paste in the terminal

```bash
curl -sS https://raw.githubusercontent.com/GoldenPalazzo/aurch/main/bootstrap.sh | bash
```

### Manually

Install `git` through

```bash
$ sudo pacman -S git
```

and then copy the repository and execute the installer.

```bash
$ cd
$ git clone https://github.com/GoldenPalazzo/aurch
$ cd aurch
$ ./install.sh
```

The guided installer is interactive. You'll only need to answer to the first
questions, grant sudo access once and then let it rip.

**NOTE:** even though the script needs sudo access, you shouldn't run it as
`root`. So make sure when installing Arch with `archinstall` to grant sudo
acess to your user or give it afterwards.

## License

This is free and open source software licensed under the GPL v3.0 license.

All of the software provided in the base installation is FOSS.
