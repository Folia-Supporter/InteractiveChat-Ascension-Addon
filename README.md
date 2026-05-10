# InteractiveChat-DiscordSRV-Addon (Ascension Fork)

A patch-based fork of [InteractiveChat-DiscordSRV-Addon](https://github.com/LOOHP/InteractiveChat-DiscordSRV-Addon) migrated to **DiscordSRV v3 (Ascension)**.

> [!WARNING]  
> **⚠️ Experimental Version**  
> This fork is primarily developed for compatibility with DiscordSRV v3 (Ascension). Currently, several features may be stubbed or have their logic removed. 100% stability is not guaranteed.

---

## Project Philosophy

This repository uses the **Patch-Based Fork** model:
- The repository itself does not store the full source code; it only stores **patch files** and **scripts**.
- Source code is automatically pulled from the Upstream and patched when running the `setup` script.
- This allows for a clear view of changes relative to the original version and makes it easy to follow upstream updates.

---

## Requirements

- Git
- JDK 8+ (JDK matching your Minecraft version is recommended)
- Maven
- Stable internet connection

---

## Setup (First Time Setup)

After cloning this repository, run the setup script:

**Windows**
```bat
setup.bat
```

**Linux / macOS**
```bash
chmod +x *.sh
./setup.sh
```

The script will:
1. Clone the upstream source code into the `src/` directory.
2. Switch to the `upstreamRef` specified in `gradle.properties` (corresponding to the stable version of the original).
3. Apply all patches in the `patches/` directory in order.

---

## Building the Project

Once the setup is complete, enter the `src` directory to build:

```bash
cd src
mvn clean install
```

The compiled JAR file will appear in `src/common/target/` (or the target directory of other modules).

---

## Daily Workflow

### 1. Updating Upstream Code
When the original version has updates you want to follow:
- Run `update-upstream.bat` (Windows) or `./update-upstream.sh` (Linux/macOS).
- The script will automatically pull the new version and attempt to rebase your patches onto it.
- **In case of conflicts**: Enter `src/`, resolve conflicts manually, and follow the script's instructions.

### 2. Modifying Code and Updating Patches
1. Modify the code directly in the `src/` directory.
2. Commit your changes inside `src/` (`git add -A && git commit`).
3. Return to the root directory and run `make-patches.bat` or `./make-patches.sh`.
4. Patch files will be regenerated; simply commit the `patches/` folder.

---

## File Structure

```
InteractiveChat-DiscordSRV-Addon/
├── gradle.properties        ← Upstream URL and pinned commit hash
├── patches/
│   └── 0001-*.patch         ← Core changes for Ascension migration
├── setup.sh / setup.bat     ← Initial setup (pull source + apply patches)
├── make-patches.sh / .bat   ← Export new patches from src/
└── update-upstream.sh / .bat← Follow upstream updates
src/                         ← Generated (ignored, do not commit)
└── ...                      ← Full Ascension version code
```

---

## Acknowledgments

- [DiscordSRV (Ascension)](https://github.com/DiscordSRV/Ascension)
- [InteractiveChat-DiscordSRV-Addon](https://github.com/LOOHP/InteractiveChat-DiscordSRV-Addon)
