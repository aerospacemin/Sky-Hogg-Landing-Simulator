function sim3d_cam_switch()
% Numpad camera control for Sim3D.
% Click the figure once to focus, then press numpad keys.
%
%   Numpad layout → viewpoint:
%   ┌──────────┬──────────┬──────────┐
%   │  7       │  8       │  9       │
%   │ Chase-L  │  Chase   │ Chase-R  │
%   ├──────────┼──────────┼──────────┤
%   │  4       │  5       │  6       │
%   │   Left   │   Top    │  Right   │
%   ├──────────┼──────────┼──────────┤
%   │  1       │  2       │  3       │
%   │ Front-L  │  Front   │ Front-R  │
%   ├────────────────────┬───────────┤
%   │  0                 │  .        │
%   │  Cockpit           │  Belly    │
%   └────────────────────┴───────────┘

blk = 'example/Visualization/Simulation 3D Scene Configuration';

% [roll, pitch, yaw] deg  |  translation [x, y, z] m (body frame, z-up)
vp.numpad7 = struct('t', '[-12 -12  -3]', 'r', '[0  -12   45]');  % Chase-Left
vp.numpad8 = struct('t', '[-15   0  -3]', 'r', '[0  -15    0]');  % Chase
vp.numpad9 = struct('t', '[-12  12  -3]', 'r', '[0  -12  -45]');  % Chase-Right
vp.numpad4 = struct('t', '[  0 -20  -2]', 'r', '[0  -10   90]');  % Left
vp.numpad5 = struct('t', '[  0   0 -40]', 'r', '[0  -90    0]');  % Top
vp.numpad6 = struct('t', '[  0  20  -2]', 'r', '[0  -10  -90]');  % Right
vp.numpad1 = struct('t', '[ 15 -12  -2]', 'r', '[0  -10  135]');  % Front-Left
vp.numpad2 = struct('t', '[ 20   0  -2]', 'r', '[0  -10  180]');  % Front
vp.numpad3 = struct('t', '[ 15  12  -2]', 'r', '[0  -10 -135]');  % Front-Right
vp.numpad0 = struct('t', '[  2   0  -1]', 'r', '[0    0    0]');  % Cockpit
vp.decimal = struct('t', '[  0   0  25]', 'r', '[0   90    0]');  % Belly

fig = buildFigure(vp, blk);
end

% ---------------------------------------------------------------
function fig = buildFigure(vp, blk)
bg   = [0.12 0.12 0.12];
fg   = [0.92 0.92 0.92];
hi   = [0.25 0.55 0.95];   % key cap accent
act  = [0.35 0.35 0.35];   % active key flash

fig = figure('Name', 'Camera View Control  |  click here, then press Numpad', ...
             'NumberTitle', 'off', ...
             'MenuBar', 'none', ...
             'ToolBar', 'none', ...
             'Color', bg, ...
             'Position', [60 60 420 310], ...
             'Resize', 'off');

ax = axes('Parent', fig, ...
          'Position', [0 0 1 1], ...
          'XLim', [0 1], 'YLim', [0 1], ...
          'Visible', 'off', ...
          'Color', bg);
ax.Toolbar.Visible = 'off';

% ASCII numpad grid definition: {key_label, view_label, col_span, xmin, ymin, w, h}
% Grid: 4 rows, 3 cols + special bottom row
pad = 0.02;
cw  = 0.30;   % cell width
ch  = 0.21;   % cell height (top 3 rows)
bh  = 0.18;   % bottom row height
lm  = 0.04;   % left margin
bm  = 0.04;   % bottom margin

cells = { ...
  '7','Chase-Left', lm,          bm+ch*3+pad*3, cw,   ch; ...
  '8','Chase',      lm+cw+pad,   bm+ch*3+pad*3, cw,   ch; ...
  '9','Chase-Right',lm+cw*2+pad*2, bm+ch*3+pad*3, cw, ch; ...
  '4','Left',       lm,          bm+ch*2+pad*2, cw,   ch; ...
  '5','Top',        lm+cw+pad,   bm+ch*2+pad*2, cw,   ch; ...
  '6','Right',      lm+cw*2+pad*2, bm+ch*2+pad*2, cw, ch; ...
  '1','Front-Left', lm,          bm+ch+pad,     cw,   ch; ...
  '2','Front',      lm+cw+pad,   bm+ch+pad,     cw,   ch; ...
  '3','Front-Right',lm+cw*2+pad*2, bm+ch+pad,   cw,   ch; ...
  '0','Cockpit',    lm,          bm,            cw*2+pad, bh; ...
  '.','Belly',      lm+cw*2+pad*2, bm,          cw,   bh; ...
};

keyMap = containers.Map( ...
    {'7','8','9','4','5','6','1','2','3','0','.'}, ...
    {'numpad7','numpad8','numpad9','numpad4','numpad5', ...
     'numpad6','numpad1','numpad2','numpad3','numpad0','decimal'});

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

title(ax, '', 'Color', fg);
fig.KeyPressFcn = @(~, evt) onKey(evt.Key, vp, blk, handles, keyMap, act, [0.20 0.20 0.22]);
end

% ---------------------------------------------------------------
function onKey(key, vp, blk, handles, keyMap, flashColor, normalColor)
% Map MATLAB key name → single character for display
charMap = containers.Map( ...
    {'numpad0','numpad1','numpad2','numpad3','numpad4', ...
     'numpad5','numpad6','numpad7','numpad8','numpad9','decimal'}, ...
    {'0','1','2','3','4','5','6','7','8','9','.'});

if ~isKey(keyMap, '') && isKey(charMap, key)
    dispKey = charMap(key);
elseif isKey(charMap, key)
    dispKey = charMap(key);
else
    % Try direct char (fallback for some systems)
    dispKey = key;
end

if ~isKey(vp, key) || ~isfield(vp(key), 't')
    % Check vp struct directly
end

% Apply view
if isfield(vp, key)
    v = vp.(key);
    try
        set_param(blk, ...
            'AttachedCameraRelativeTranslation', v.t, ...
            'AttachedCameraRelativeRotation',    v.r);
    catch
    end

    % Flash key cap
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
end
