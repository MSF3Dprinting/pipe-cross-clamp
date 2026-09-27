#!/usr/bin/env bash
# install_openscad.sh — set up OpenSCAD and the check tooling in a fresh sandbox (MSF "3D Printing for All").
# Tested in the Claude sandbox (Ubuntu 24.04): OpenSCAD 2021.01 from apt + xvfb for headless PNG.
# The snapshot host files.openscad.org is usually unreachable there (403); pass --snapshot URL to try one.
# Usage:  bash scripts/install_openscad.sh [--snapshot https://files.openscad.org/snapshots/OpenSCAD-<date>-x86_64.AppImage]
set -u
SNAP=""
[ "${1:-}" = "--snapshot" ] && SNAP="${2:-}"
SUDO=""; command -v sudo >/dev/null 2>&1 && [ "$(id -u)" != "0" ] && SUDO="sudo"
export DEBIAN_FRONTEND=noninteractive

# 1. a broken third-party apt list breaks apt-get update in some images
$SUDO rm -f /etc/apt/sources.list.d/nodesource* 2>/dev/null || true

# 2. foreground install with a timeout — background installs die when a tool call returns
if ! command -v openscad >/dev/null 2>&1; then
  timeout 600 bash -c "$SUDO apt-get update -qq && $SUDO apt-get install -y -qq --no-install-recommends openscad xvfb" \
    || echo "apt install failed — check the network settings"
fi

# 3. optional snapshot AppImage (Manifold backend, fast renders, native headless PNG)
if [ -n "$SNAP" ]; then
  $SUDO apt-get install -y -qq --no-install-recommends libegl1 libgl1 libopengl0 libgbm1 libwayland-client0 libfontconfig1 libharfbuzz0b libgmp10 >/dev/null 2>&1 || true
  if curl -fsSL --max-time 120 -o /tmp/openscad.AppImage "$SNAP"; then
    chmod +x /tmp/openscad.AppImage && (cd /tmp && ./openscad.AppImage --appimage-extract >/dev/null 2>&1) \
      && $SUDO ln -sf /tmp/squashfs-root/AppRun /usr/local/bin/openscad && echo "snapshot installed"
  else
    echo "snapshot host not reachable — staying with the apt version"
  fi
fi

# 4. python tooling for the checks (shapely + rtree for sections, scipy for the footprint)
timeout 300 pip install -q trimesh numpy scipy shapely rtree pillow --break-system-packages 2>&1 | tail -1

echo "openscad: $(openscad --version 2>&1 | head -1)"
python3 -c "import trimesh, shapely, scipy, PIL; print('python tooling ok')"
echo "Headless PNG with 2021.01:  xvfb-run -a openscad -o out.png --render=true ...   (render_views.py does this for you)"
