# SkyHogg Sim3D — Aerospace Blockset 3D Visualization Example (Modified)

A modified version of the official MathWorks example  
**"Using Simulation 3D Visualization with Aerospace Blockset"**  
(`aeroblks/UsingSimulation3DVisualizationWithAerospaceBlocksetExample`),  
with **standalone execution** and **numpad camera control** added.

---

## Copyright & Attribution

© MathWorks, Inc. — Original example and all associated assets (`asbSkyHoggData.mat`, `SkyHoggSim3DExampleModel.slx`, Sky Hogg aircraft model) are the intellectual property of MathWorks, Inc. and are subject to the [MathWorks Software License Agreement](https://www.mathworks.com/license).

Modified by **aerospacemin** — [github.com/aerospacemin](https://github.com/aerospacemin)  
Modifications: standalone `PreLoadFcn`, removed `PostLoadFcn` auto-launch, numpad camera control (`sim3d_cam_switch.m`).

---

## Requirements

| Item | Version |
|------|---------|
| MATLAB | R2026a (26.1) or later recommended |
| Simulink | R2026a |
| Aerospace Blockset | R2026a |
| Aerospace Toolbox | R2026a |
| Simulation 3D (Unreal Engine integration) | Bundled with Aerospace Blockset |

> **Sim3D rendering** uses the Unreal Engine environment (`sim3dlib`) bundled with Aerospace Blockset.  
> No separate UE installation is required, but Aerospace Blockset must be installed.

---

## Included Files

```
example.slx          ← Modified Simulink model
sim3d_cam_switch.m   ← Numpad camera control function
README.md
```

---

## Required Resource Files (not included)

| File | Source | Description |
|------|--------|-------------|
| `asbSkyHoggData.mat` | MATLAB example folder | Digital DATCOM aerodynamic data (`statdyn`) |

`asbSkyHoggData.mat` is a MathWorks-licensed file and is **not included** in this repository.  
It is automatically generated when MATLAB R2026a is installed, at the following path:

```
%USERPROFILE%\Documents\MATLAB\Examples\R2026a\aeroblks\
  UsingSimulation3DVisualizationWithAerospaceBlocksetExample\
    asbSkyHoggData.mat
```

When `example.slx` is opened, the `PreLoadFcn` automatically searches for and loads this file.  
An error message is displayed if the file cannot be found.

---

## How to Run

1. Start MATLAB.
2. Open `example.slx` (double-click or `open_system`).  
   → The `PreLoadFcn` automatically searches for and loads `asbSkyHoggData.mat`.
3. Click **Run** (▶).  
   → The `StartFcn` calls `sim3d_cam_switch()`, opening the camera control figure.
4. Click the camera control figure once to focus it, then use the **numpad** to switch viewpoints.

> `sim3d_cam_switch.m` and `example.slx` must be in the **same folder**.

---

## Aircraft Initial Conditions (Sky Hogg)

> Values from the `asbSkyHogg` model workspace.

| Variable | Value | Unit | Description |
|----------|-------|------|-------------|
| `V0` | 93.10 | m/s | Initial airspeed (≈ 181 kt) |
| `alpha0` | 0.01709 | rad (≈ 0.98°) | Initial angle of attack |
| `beta0` | 0 | rad | Initial sideslip angle |
| `alt0` | 2000 | m | Initial altitude |
| `theta0` | 0.01709 | rad | Initial pitch angle (≈ alpha0, level flight) |
| `heading0` | 0 | rad | Initial heading (due north) |
| `LatLong0` | [45, 120] | deg | Initial latitude / longitude |
| `mass` | 1299.21 | kg | Aircraft mass |
| `inertia` | diag: Ixx=5788, Iyy=6929, Izz=11578 | kg·m² | Inertia tensor |
| `cg_0` | [2.158, 0, 0] | m | Center of gravity position (from reference point) |
| `Sref` | 20.98 | m² | Reference wing area |
| `bref` | 12.54 | m | Reference wingspan |
| `cbar` | 1.7526 | m | Reference mean aerodynamic chord |
| `g_0` | [0, 0, 9.81] | m/s² | Gravity vector (NED, z-down) |

---

## Numpad Camera Viewpoints

Camera transform reference: **body-fixed frame** (X = forward, Y = right, Z = up)

```
┌──────────┬──────────┬──────────┐
│  7       │  8       │  9       │
│ Front-L  │  Front   │ Front-R  │
├──────────┼──────────┼──────────┤
│  4       │  5       │  6       │
│   Left   │ Cockpit  │  Right   │
├──────────┼──────────┼──────────┤
│  1       │  2       │  3       │
│ Chase-L  │  Chase   │ Chase-R  │
├──────────────────────────────────┤
│  0                               │
│  Top                             │
└──────────────────────────────────┘
```

| Key | Viewpoint | Translation [x, y, z] m | Rotation [roll, pitch, yaw] ° |
|-----|-----------|--------------------------|-------------------------------|
| `7` | Front-Left | [15, -12, -2] | [0, -10, 135] |
| `8` | Front | [20, 0, -2] | [0, -10, 180] |
| `9` | Front-Right | [15, 12, -2] | [0, -10, -135] |
| `4` | Left | [0, -20, -2] | [0, -10, 90] |
| `5` | Cockpit | [2, 0, -1] | [0, 0, 0] |
| `6` | Right | [0, 20, -2] | [0, -10, -90] |
| `1` | Chase-Left | [-12, -12, -3] | [0, -12, 45] |
| `2` | Chase | [-15, 0, -3] | [0, -15, 0] |
| `3` | Chase-Right | [-12, 12, -3] | [0, -12, -45] |
| `0` | Top | [0, 0, -40] | [0, -90, 0] |

When a key is pressed, the corresponding key cell in the camera control figure briefly flashes blue to confirm the viewpoint switch.

---

## Changes from the Original Example

### 1. PreLoadFcn — Automatic data loading (modified)

| | Content |
|--|---------|
| **Original** | `load asbSkyHoggData.mat` (fails if the example folder is not on the MATLAB path) |
| **Modified** | Automatically searches via `which()` → `userpath` → `matlabroot` fallback, then loads |

```matlab
% Before (SkyHoggSim3DExampleModel)
load asbSkyHoggData.mat

% After (example.slx)
matFile = which('asbSkyHoggData.mat');
if isempty(matFile)
    candidates = {
        fullfile(userpath, 'Examples', 'R2026a', 'aeroblks', ...
            'UsingSimulation3DVisualizationWithAerospaceBlocksetExample', 'asbSkyHoggData.mat'), ...
        fullfile(matlabroot, 'examples', 'aeroblks', 'main', 'asbSkyHoggData.mat') ...
    };
    for k__ = 1:numel(candidates)
        if exist(candidates{k__}, 'file')
            matFile = candidates{k__}; break;
        end
    end
end
if ~isempty(matFile)
    addpath(fileparts(matFile)); load(matFile);
else
    error('Cannot find asbSkyHoggData.mat. Add the example folder to the MATLAB path.');
end
clear matFile candidates k__
```

### 2. PostLoadFcn — Removed unnecessary example re-launch (modified)

| | Content |
|--|---------|
| **Original** | `openExample("aeroblks/UsingSimulation3DVisualizationWithAerospaceBlocksetExample")` |
| **Modified** | Cleared — removes the behavior that reopened the Live Script on every model open |

### 3. StartFcn — Automatic camera control launch (added)

| | Content |
|--|---------|
| **Original** | Empty |
| **Modified** | `sim3d_cam_switch()` — automatically opens the camera control figure when simulation starts |

### 4. Added Blocks

| Block Path | Purpose |
|------------|---------|
| `Pilot/SimClock` | Simulation time reference |
| `Pilot/Throttle Decay` | Throttle decay logic |
| `Visualization/WoW Scope` | Weight-on-Wheels signal monitoring |
| `Visualization/Xe Demux` | Earth-fixed position signal demux |

### 5. Removed Blocks

| Block Path | Reason |
|------------|--------|
| `Visualization/Terminator` | Placeholder for unconnected signals — replaced by actual signal routing |

---

## Recommended Repository Structure for GitHub

```
your-repo/
├── example.slx          ← Modified model
├── sim3d_cam_switch.m   ← Camera control
├── README.md
└── .gitignore
```

### Recommended .gitignore

```
*.slxc        # Simulink compile cache
*.asv         # MATLAB auto-save
*.mat         # Data files (license restrictions)
```

> `.slxc` files (`SkyHoggSim3DExampleModel.slxc`, `example.slxc`) are auto-generated  
> Simulink cache files and do not need to be included in the repository.  
> `asbSkyHoggData.mat` is a MathWorks asset and **must not be redistributed**.

---

## References

- MathWorks — [Using Simulation 3D Visualization with Aerospace Blockset](https://www.mathworks.com/help/aeroblks/ug/using-simulation-3d-visualization-with-aerospace-blockset.html)
- MathWorks — [Sky Hogg Lightweight Airplane Design](https://www.mathworks.com/help/aeroblks/ug/lightweight-airplane-design.html)
- Digital DATCOM: USAF Stability and Control Digital DATCOM, AFFDL-TR-79-3032
