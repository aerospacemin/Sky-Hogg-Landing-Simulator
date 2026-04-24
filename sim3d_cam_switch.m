function sim3d_cam_switch()
% Numpad camera control for Sim3D.
% Click the figure once to focus, then press numpad keys.
%
%   Numpad layout → viewpoint:
%   ┌──────────┬──────────┬──────────┐
%   │  7       │  8       │  9       │
%   │ Front-L  │  Front   │ Front-R  │
%   ├──────────┼──────────┼──────────┤
%   │  4       │  5       │  6       │
%   │   Left   │ Cockpit  │  Right   │
%   ├──────────┼──────────┼──────────┤
%   │  1       │  2       │  3       │
%   │ Chase-L  │  Chase   │ Chase-R  │
%   ├──────────────────────────────────┤
%   │  0                               │
%   │  Top                             │
%   └──────────────────────────────────┘

blk = 'example/Visualization/Simulation 3D Scene Configuration';

% [roll, pitch, yaw] deg  |  translation [x, y, z] m (body frame, z-up)
vp.numpad7 = struct('t', '[ 15 -12  -2]', 'r', '[0  -10  135]');  % Front-Left
vp.numpad8 = struct('t', '[ 20   0  -2]', 'r', '[0  -10  180]');  % Front
vp.numpad9 = struct('t', '[ 15  12  -2]', 'r', '[0  -10 -135]');  % Front-Right
vp.numpad4 = struct('t', '[  0 -20  -2]', 'r', '[0  -10   90]');  % Left
vp.numpad5 = struct('t', '[  2   0  -1]', 'r', '[0    0    0]');  % Cockpit
vp.numpad6 = struct('t', '[  0  20  -2]', 'r', '[0  -10  -90]');  % Right
vp.numpad1 = struct('t', '[-12 -12  -3]', 'r', '[0  -12   45]');  % Chase-Left
vp.numpad2 = struct('t', '[-15   0  -3]', 'r', '[0  -15    0]');  % Chase
vp.numpad3 = struct('t', '[-12  12  -3]', 'r', '[0  -12  -45]');  % Chase-Right
vp.numpad0 = struct('t', '[  0   0 -40]', 'r', '[0  -90    0]');  % Top

fig = buildFigure(vp, blk);
end

% ---------------------------------------------------------------
function fig = buildFigure(vp, blk)
bg  = [0.12 0.12 0.12];
fg  = [0.92 0.92 0.92];
hi  = [0.25 0.55 0.95];
act = [0.35 0.35 0.35];

fig = figure('Name', 'Camera View Control  |  click here, then press Numpad', ...
             'NumberTitle', 'off', ...
             'MenuBar', 'none', ...
             'ToolBar', 'none', ...
             'Color', bg, ...
             'Position', [60 60 420 280], ...
             'Resize', 'off');

ax = axes('Parent', fig, ...
          'Position', [0 0 1 1], ...
          'XLim', [0 1], 'YLim', [0 1], ...
          'Visible', 'off', ...
          'Color', bg);
ax.Toolbar.Visible = 'off';

pad = 0.02;
cw  = 0.30;
ch  = 0.22;
bh  = 0.18;
lm  = 0.04;
bm  = 0.04;

% {key_label, view_label, x, y, w, h}
cells = { ...
  '7', 'Front-Left',  lm,            bm+ch*3+pad*3, cw,         ch; ...
  '8', 'Front',       lm+cw+pad,     bm+ch*3+pad*3, cw,         ch; ...
  '9', 'Front-Right', lm+cw*2+pad*2, bm+ch*3+pad*3, cw,         ch; ...
  '4', 'Left',        lm,            bm+ch*2+pad*2, cw,         ch; ...
  '5', 'Cockpit',     lm+cw+pad,     bm+ch*2+pad*2, cw,         ch; ...
  '6', 'Right',       lm+cw*2+pad*2, bm+ch*2+pad*2, cw,         ch; ...
  '1', 'Chase-Left',  lm,            bm+ch+pad,     cw,         ch; ...
  '2', 'Chase',       lm+cw+pad,     bm+ch+pad,     cw,         ch; ...
  '3', 'Chase-Right', lm+cw*2+pad*2, bm+ch+pad,     cw,         ch; ...
  '0', 'Top',         lm,            bm,            cw*3+pad*2, bh; ...
};

keyMap = containers.Map( ...
    {'1','2','3','4','5','6','7','8','9','0'}, ...
    {'numpad1','numpad2','numpad3','numpad4','numpad5', ...
     'numpad6','numpad7','numpad8','numpad9','numpad0'});

handles = containers.Map();

for i = 1:size(cells,1)
    label  = cells{i,1};
    vpName = cells{i,2};
    x = cells{i,3}; y = cells{i,4};
    w = cells{i,5}; h = cells{i,6};

    r = rectangle('Parent', ax, ...
                  'Position', [x y w h], ...
                  'Curvature', [0.12 0.12], ...
                  'FaceColor', [0.20 0.20 0.22], ...
                  'EdgeColor', hi, ...
                  'LineWidth', 1.2);

    text(ax, x+0.035, y+h-0.04, label, ...
         'Color', hi, 'FontSize', 13, 'FontWeight', 'bold', ...
         'VerticalAlignment', 'top');

    text(ax, x+w/2, y+h*0.38, vpName, ...
         'Color', fg, 'FontSize', 8.5, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

    handles(label) = r;
end

fig.KeyPressFcn = @(~, evt) onKey(evt.Key, vp, blk, handles, keyMap, act, [0.20 0.20 0.22]);
end

% ---------------------------------------------------------------
function onKey(key, vp, blk, handles, keyMap, flashColor, normalColor)
charMap = containers.Map( ...
    {'numpad0','numpad1','numpad2','numpad3','numpad4', ...
     'numpad5','numpad6','numpad7','numpad8','numpad9'}, ...
    {'0','1','2','3','4','5','6','7','8','9'});

if ~isfield(vp, key)
    return
end

v = vp.(key);
try
    set_param(blk, ...
        'AttachedCameraRelativeTranslation', v.t, ...
        'AttachedCameraRelativeRotation',    v.r);
catch
end

if isKey(charMap, key)
    dk = charMap(key);
    if isKey(handles, dk)
        r = handles(dk);
        r.FaceColor = flashColor;
        drawnow;
        pause(0.12);
        r.FaceColor = normalColor;
        drawnow;
    end
end
end
