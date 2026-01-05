I = [25,6,13,14,20];
% x_query = [];
% Val = {};
% for i = 1:length(I)
%     x_query = groupPositions(I(i),:);
%     Temp = [];
%     for j = 1:length(x_query)
%         [yVals, T] = getBarValuesAtX('New_picture.fig', x_query(j));
%         Temp = [Temp,yVals];
%     end
%     Val{i,1} = I(i);
%     Val{i,2} = Temp;
% end

i = 20;
plotGroup3SingleFigsFromFig('New_picture.fig', i);


function [yVals, T] = getBarValuesAtX(figFile, x_i, tol)
%GETBARVALUESATX 从 .fig 文件中提取指定 X 坐标处所有 bar 的数值
%
% 用法：
%   [yVals, T] = getBarValuesAtX('New_picture.fig', x_i)
%   [yVals, T] = getBarValuesAtX('New_picture.fig', x_i, tol)
%
% 输入：
%   figFile : .fig 文件路径（例如 'New_picture.fig'）
%   x_i     : 要查询的 X 坐标（标量或向量）
%   tol     : 比较容差（默认 1e-9，用于浮点误差）
%
% 输出：
%   yVals : 所有匹配到的 bar 的 Y 值（列向量）
%   T     : 详细信息表（包含在哪个子图Axes、哪个Bar对象等）

    if nargin < 3 || isempty(tol)
        tol = 1e-9;
    end

    if ~isfile(figFile)
        error('找不到文件：%s', figFile);
    end

    % 1) 打开 fig（尽量不显示）
    try
        fig = openfig(figFile, 'new', 'invisible');
    catch
        fig = openfig(figFile, 'new');
        set(fig, 'Visible', 'off');
    end
    c = onCleanup(@() close(fig)); %#ok<NASGU>

    % 2) 找到所有 axes（排除 legend 的 axes）
    axs = findall(fig, 'Type', 'axes');
    axs = axs(~arrayfun(@(a) strcmpi(get(a,'Tag'), 'legend'), axs));

    x_i = x_i(:);     % 支持输入向量
    rows = {};
    yVals = [];

    % ---------- 优先：按 Bar 对象读取（新版本 MATLAB 通常都有） ----------
    bars = findall(fig, '-isa', 'matlab.graphics.chart.primitive.Bar');
    if isempty(bars)
        % 某些版本可能 Type 是 'bar'
        bars = findall(fig, 'Type', 'bar');
    end

    for bi = 1:numel(bars)
        b = bars(bi);
        ax = ancestor(b, 'axes');
        if isempty(ax) || strcmpi(get(ax,'Tag'),'legend')
            continue;
        end

        % bar 的“中心 X 坐标”
        if isprop(b, 'XEndPoints') && ~isempty(b.XEndPoints)
            xPos = b.XEndPoints(:);
        else
            xPos = b.XData(:);
        end
        yPos = b.YData(:);

        for xi = 1:numel(x_i)
            idx = find(abs(xPos - x_i(xi)) <= tol);
            for k = idx.'
                yVals(end+1,1) = yPos(k); %#ok<AGROW>

                axNo = find(axs == ax, 1, 'first');
                if isempty(axNo); axNo = NaN; end

                ylbl = "";
                try
                    yl = get(get(ax,'YLabel'),'String');
                    if iscell(yl); yl = strjoin(yl,' '); end
                    ylbl = string(yl);
                catch
                end

                rows(end+1,:) = {x_i(xi), yPos(k), "Bar", bi, k, axNo, ylbl}; %#ok<AGROW>
            end
        end
    end

    % ---------- 退化方案：如果没找到 Bar（或 Bar 没匹配到），解析 patch ----------
    if isempty(rows)
        patches = findall(fig, 'Type', 'patch');

        for pi = 1:numel(patches)
            p = patches(pi);
            ax = ancestor(p, 'axes');
            if isempty(ax) || strcmpi(get(ax,'Tag'),'legend')
                continue;
            end

            X = get(p,'XData');
            Y = get(p,'YData');
            if isempty(X) || isempty(Y) || isvector(X) || isvector(Y)
                continue;
            end

            % bar 的 patch 通常每一列是一根柱子的多边形顶点
            nCols = min(size(X,2), size(Y,2));
            X = X(:,1:nCols);
            Y = Y(:,1:nCols);

            validCol = ~all(isnan(X),1) & ~all(isnan(Y),1);
            X = X(:,validCol);
            Y = Y(:,validCol);
            if isempty(X)
                continue;
            end

            r = min(4, size(X,1)); % 前 4 个点足以算中心
            xCenter = mean(X(1:r,:), 1, 'omitnan');

            yTop = max(Y, [], 1, 'omitnan');
            yBottom = min(Y, [], 1, 'omitnan');
            yVal = yTop;
            negMask = abs(yBottom) > abs(yTop);
            yVal(negMask) = yBottom(negMask);

            for xi = 1:numel(x_i)
                idx = find(abs(xCenter - x_i(xi)) <= tol);
                for k = idx(:).'
                    yVals(end+1,1) = yVal(k); %#ok<AGROW>

                    axNo = find(axs == ax, 1, 'first');
                    if isempty(axNo); axNo = NaN; end

                    ylbl = "";
                    try
                        yl = get(get(ax,'YLabel'),'String');
                        if iscell(yl); yl = strjoin(yl,' '); end
                        ylbl = string(yl);
                    catch
                    end

                    rows(end+1,:) = {x_i(xi), yVal(k), "Patch", pi, k, axNo, ylbl}; %#ok<AGROW>
                end
            end
        end
    end

    % 3) 输出结果表
    if isempty(rows)
        T = table();
        fprintf('未在 "%s" 中找到 X=%.15g (tol=%.1e) 的 bar。\n', figFile, x_i(1), tol);
    else
        T = cell2table(rows, 'VariableNames', ...
            {'X_query','Y_value','ObjType','ObjIndex','PointIndex','AxesNo','YLabel'});

        fprintf('在 "%s" 中找到 %d 个匹配的 bar（tol=%.1e）。明细如下：\n', figFile, size(T,1), tol);
        disp(T);
    end
end

function xr = getGroupXRangeFromAxis(ax, i)
    % 根据该 axes 的 XTickLabel 得到该段的起始层号，从而算出 i 在该 axes 内的索引
    xtl = get(ax, 'XTickLabel');
    if ischar(xtl)
        xtl = cellstr(xtl);
    end
    xtl = string(xtl);
    layerLabels = str2double(xtl);
    layerLabels = layerLabels(~isnan(layerLabels));

    if isempty(layerLabels)
        xr = [NaN NaN];
        return;
    end

    startLayer = min(layerLabels);
    idx = i - startLayer + 1;  % i 在该 axes 里的第几个（1-based）
    if idx < 1
        xr = [NaN NaN];
        return;
    end

    % 找 bar 对象
    bars = findall(ax, '-isa', 'matlab.graphics.chart.primitive.Bar');
    if isempty(bars)
        bars = findall(ax, 'Type', 'bar'); % 兼容
    end

    xs = [];

    if ~isempty(bars)
        for b = bars(:).'
            % 取该 layer 对应的 x 位置
            if isprop(b, 'XEndPoints') && ~isempty(b.XEndPoints)
                xvec = b.XEndPoints(:);
            else
                xvec = b.XData(:);
            end
            if idx <= numel(xvec)
                xs(end+1) = xvec(idx); %#ok<AGROW>
            end
        end
    else
        % 兼容：老版本可能存成 patch
        patches = findall(ax, 'Type', 'patch');
        for p = patches(:).'
            X = get(p,'XData');
            if isempty(X) || isvector(X)
                continue;
            end
            % 每列一根柱子，柱中心取前几行均值
            nCols = size(X,2);
            r = min(4, size(X,1));
            xCenter = mean(X(1:r,:), 1, 'omitnan');

            % 该 axes 覆盖的层数 = nCols（一般为 9 或 8）
            if idx <= nCols
                xs(end+1) = xCenter(idx); %#ok<AGROW>
            end
        end
    end

    if isempty(xs)
        xr = [NaN NaN];
        return;
    end

    % 你原始代码中：相邻组之间起点差为 24，组内最大 x 到下一组最小 x 有 2 的间隔
    % 为避免把相邻组带进来，这里 margin 取 1（安全）
    margin = 1;
    xr = [min(xs)-margin, max(xs)+margin];
end

function figs = plotGroup3SingleFigsFromFig(figFile, groupIdx)
%PLOTGROUP3SINGLEFIGSFROMFIG
% 输入 groupIdx(1~25)，从 New_picture.fig 提取该组，输出三张独立图：
%   1) Communicational
%   2) Computational
%   3) Localization Error (Accuracy)
%
% 每张图大小/axes位置/字体等参考你给的模板：
% fig: Position [100 100 170 140]
% ax : Position [0.13 0.17 0.86 0.68]
% title: SimSun 12
% tick : 9
% bar linewidth: 0.1
%
% 用法：
%   figs = plotGroup3SingleFigsFromFig('New_picture.fig', 12);

    if nargin < 1 || isempty(figFile)
        figFile = 'New_picture.fig';
    end
    validateattributes(groupIdx, {'numeric'}, {'scalar','integer','>=',1,'<=',25});

    if ~isfile(figFile)
        error('找不到 .fig 文件：%s', figFile);
    end

    % 打开旧 fig（尽量不显示）
    try
        oldFig = openfig(figFile, 'new', 'invisible');
    catch
        oldFig = openfig(figFile, 'new');
        set(oldFig, 'Visible', 'off');
    end
    c = onCleanup(@() close(oldFig)); %#ok<NASGU>

    % 找到包含该 groupIdx 的 3 个 axes（排除 legend）
    allAx = findall(oldFig, 'Type', 'axes');
    allAx = allAx(~arrayfun(@(a) strcmpi(get(a,'Tag'), 'legend'), allAx));

    axPick = gobjects(0);
    for k = 1:numel(allAx)
        if axisHasGroupLabel(allAx(k), groupIdx)
            axPick(end+1) = allAx(k); %#ok<AGROW>
        end
    end
    if numel(axPick) ~= 3
        error('未能定位到恰好 3 个包含组 %d 的子图（实际 %d 个）。', groupIdx, numel(axPick));
    end

    % 识别三个子图类型：Comm / Compu / Acc
    axComm  = gobjects(1);
    axCompu = gobjects(1);
    axAcc   = gobjects(1);

    for k = 1:3
        t = getAxisType(axPick(k));
        switch t
            case "comm"
                axComm = axPick(k);
            case "compu"
                axCompu = axPick(k);
            otherwise
                axAcc = axPick(k);
        end
    end

    % 兜底：如果没识别出 Accuracy，则线性 YScale 的多半是 Accuracy
    if ~isgraphics(axAcc)
        for k = 1:3
            if strcmpi(get(axPick(k),'YScale'), 'linear')
                axAcc = axPick(k);
            end
        end
    end

    if ~(isgraphics(axComm) && isgraphics(axCompu) && isgraphics(axAcc))
        error('无法可靠识别 Communicational / Computational / Accuracy 三个 axes。');
    end

    % 计算 groupIdx 在该 axes 片段中的局部索引 idx
    idxC = getLocalIndex(axComm, groupIdx);
    idxP = getLocalIndex(axCompu, groupIdx);
    idxA = getLocalIndex(axAcc, groupIdx);
    if any([idxC idxP idxA] < 1)
        error('无法计算组 %d 的局部索引。', groupIdx);
    end

    % 从 fig 中提取该组的 bar (x,y,color)，并排序
    [xC, yC, colC] = extractBarsAtIndex(axComm,  idxC);
    [xP, yP, colP] = extractBarsAtIndex(axCompu, idxP);
    [xA, yA, colA] = extractBarsAtIndex(axAcc,   idxA);

    if isempty(xC) || isempty(xP) || isempty(xA)
        error('提取 bar 数据失败：某个子图中没找到 bar。');
    end

    % 统一 xlim（保证三张图的分割线位置一致）
    margin = 1;
    xMin = min([xC(:); xP(:); xA(:)]) - margin;
    xMax = max([xC(:); xP(:); xA(:)]) + margin;
    xlimUnified = [xMin, xMax];

    % x tick：只标当前组号（和你的小图风格一致，避免 14 个标签挤爆）
    xCenter = median(xA);

    % 三张图位置（避免叠在一起）
    basePos = [100, 100, 170, 140];
    pos1 = basePos;
    pos2 = basePos; pos2(1) = basePos(1) + 190;
    pos3 = basePos; pos3(1) = basePos(1) + 380;

    figs = struct();

    % 1) Communicational（左）
    figs.Communicational = drawSingleFig( ...
        pos1, xC, yC, colC, get(axComm,'YScale'), ...
        'Communicational Cost', xlimUnified, xCenter, groupIdx, axComm);

    % 2) Computational（中）
    figs.Computational = drawSingleFig( ...
        pos2, xP, yP, colP, get(axCompu,'YScale'), ...
        'Computational Cost', xlimUnified, xCenter, groupIdx, axCompu);

    % 3) Accuracy（右）
    figs.Accuracy = drawSingleFig( ...
        pos3, xA, yA, colA, get(axAcc,'YScale'), ...
        'Localization Error', xlimUnified, xCenter, groupIdx, axAcc);

end

% ========================= 绘图（单张） =========================
function fig = drawSingleFig(figPos, xVals, yVals, rgb, yScale, ttl, xlimUnified, xCenter, groupIdx, axOldForLines)

    fig = figure('Color',[1,1,1], 'Position', figPos);
    ax  = axes('Parent', fig, 'Position', [0.13, 0.17, 0.86, 0.68]);

    % bar 加粗：根据最小 x 间距自适应（并设置上下限）
    dx = diff(sort(unique(xVals)));
    if isempty(dx)
        W = 0.6;
    else
        W = 0.6 * min(dx);     % “适当加粗”
        W = max(W, 0.25);      % 不要太细
        W = min(W, 0.85);      % 不要太粗导致重叠
    end

    % 画柱子：一个 bar 对象 + flat 颜色（每根柱子不同色）
    b = bar(ax, xVals, yVals, W, 'FaceColor','flat', 'LineWidth', 0.1);
    b.CData = rgb;

    % 字体/标题/坐标设置（按你参考代码）
    title(ax, ttl, 'FontName', 'Times New Roman', 'FontSize', 10);
    set(ax, 'FontName','Helvetica', 'FontSize', 9);

    set(ax, 'YScale', yScale);
    xlim(ax, xlimUnified);
    set(ax, 'XTick', xCenter, 'XTickLabel', {num2str(groupIdx)}, 'FontSize', 9);

    % 先让 MATLAB 自动算一次 ylim，再按你的规则扩展下边界
    ylim1 = ylim(ax);
    if strcmpi(yScale, 'log')
        low = 0.5 * ylim1(1);
        if low <= 0
            % 保险：log 轴必须 >0
            posMin = min(yVals(yVals > 0));
            if isempty(posMin), posMin = 1e-3; end
            low = 0.5 * posMin;
        end
        ylim(ax, [low, ylim1(2)]);
    else
        ylim(ax, [0.5 * ylim1(1), ylim1(2)]);
    end

    % === 关键：恢复原图的竖直虚线/实线分割线 ===
    addVerticalSeparatorLines(ax, axOldForLines, xlimUnified);

end

% ========================= 分割线恢复 =========================
function addVerticalSeparatorLines(axNew, axOld, xlimUnified)
    % 从旧 axes 中找出竖直线条（XData=[x x]），复制其 style/color 到新 axes

    linesOld = findall(axOld, 'Type', 'line');
    if isempty(linesOld)
        return;
    end

    tol = 1e-12;
    xs = [];
    styles = {};
    cols = {};
    lws = [];

    for h = linesOld(:).'
        x = get(h,'XData');
        if isempty(x) || numel(x) < 2
            continue;
        end
        % 竖直线：x 全相等
        if max(abs(x - x(1))) > tol
            continue;
        end

        x0 = x(1);
        if x0 < xlimUnified(1)-1e-6 || x0 > xlimUnified(2)+1e-6
            continue;
        end

        xs(end+1,1) = x0; %#ok<AGROW>
        styles{end+1,1} = get(h,'LineStyle'); %#ok<AGROW>
        cols{end+1,1} = get(h,'Color'); %#ok<AGROW>
        lws(end+1,1) = get(h,'LineWidth'); %#ok<AGROW>
    end

    if isempty(xs)
        return;
    end

    % 去重（同一个 x 位置可能重复画过）
    [xsU, ia] = unique(xs, 'stable');
    styles = styles(ia);
    cols = cols(ia);
    lws = lws(ia);

    yl = ylim(axNew);

    hold(axNew, 'on');
    for k = 1:numel(xsU)
        line(axNew, [xsU(k) xsU(k)], yl, ...
            'Color', cols{k}, ...
            'LineStyle', styles{k}, ...
            'LineWidth', lws(k));
    end
    hold(axNew, 'off');
end

% ========================= 从旧 axes 提取组数据 =========================
function [xVals, yVals, rgb] = extractBarsAtIndex(ax, idx)
    bars = findall(ax, '-isa', 'matlab.graphics.chart.primitive.Bar');
    if isempty(bars)
        bars = findall(ax, 'Type', 'bar');
    end

    xVals = []; yVals = []; rgb = zeros(0,3);

    % 优先 Bar 对象
    if ~isempty(bars)
        for b = bars(:).'
            if isprop(b,'XEndPoints') && ~isempty(b.XEndPoints)
                xvec = b.XEndPoints(:);
            else
                xvec = b.XData(:);
            end
            yvec = b.YData(:);

            if idx > numel(xvec) || idx > numel(yvec)
                continue;
            end

            x = xvec(idx);
            y = yvec(idx);

            % 颜色
            c = [];
            try
                fc = b.FaceColor;
                if isnumeric(fc) && numel(fc)==3
                    c = fc(:).';
                elseif (ischar(fc) || isstring(fc)) && strcmpi(string(fc), "flat")
                    cd = [];
                    if isprop(b,'CData'); cd = b.CData; end
                    if isnumeric(cd) && size(cd,2)==3
                        if size(cd,1) >= idx
                            c = cd(idx,:);
                        else
                            c = cd(1,:);
                        end
                    end
                end
            catch
            end
            if isempty(c)
                c = [0.5 0.5 0.5];
            end

            xVals(end+1,1) = x; %#ok<AGROW>
            yVals(end+1,1) = y; %#ok<AGROW>
            rgb(end+1,:) = c; %#ok<AGROW>
        end

        [xVals, ord] = sort(xVals);
        yVals = yVals(ord);
        rgb   = rgb(ord,:);
        return;
    end

    % 兼容：若保存成 patch（一般不会，但加上更稳）
    patches = findall(ax, 'Type', 'patch');
    for p = patches(:).'
        X = get(p,'XData');
        Y = get(p,'YData');
        if isempty(X) || isempty(Y) || isvector(X) || isvector(Y)
            continue;
        end

        nCols = min(size(X,2), size(Y,2));
        if idx > nCols
            continue;
        end

        r = min(4, size(X,1));
        xCenter = mean(X(1:r, idx), 'omitnan');

        yTop = max(Y(:,idx), [], 'omitnan');
        yBottom = min(Y(:,idx), [], 'omitnan');
        yVal = yTop;
        if abs(yBottom) > abs(yTop)
            yVal = yBottom;
        end

        c = get(p,'FaceColor');
        if ~isnumeric(c) || numel(c)~=3
            c = [0.5 0.5 0.5];
        end

        xVals(end+1,1) = xCenter; %#ok<AGROW>
        yVals(end+1,1) = yVal; %#ok<AGROW>
        rgb(end+1,:) = c; %#ok<AGROW>
    end

    [xVals, ord] = sort(xVals);
    yVals = yVals(ord);
    rgb   = rgb(ord,:);
end

% ========================= 识别 groupIdx 是否在该 axes =========================
function tf = axisHasGroupLabel(ax, groupIdx)
    xtl = get(ax, 'XTickLabel');
    if isempty(xtl)
        tf = false; return;
    end
    if ischar(xtl); xtl = cellstr(xtl); end
    vals = str2double(string(xtl));
    vals = vals(~isnan(vals));
    tf = any(vals == groupIdx);
end

function idx = getLocalIndex(ax, groupIdx)
    xtl = get(ax,'XTickLabel');
    if ischar(xtl); xtl = cellstr(xtl); end
    vals = str2double(string(xtl));
    vals = vals(~isnan(vals));
    if isempty(vals)
        idx = -1; return;
    end
    startLayer = min(vals);
    idx = groupIdx - startLayer + 1;
end

function t = getAxisType(ax)
    ylbl = "";
    try
        s = get(get(ax,'YLabel'),'String');
        if iscell(s); s = strjoin(string(s)," "); end
        ylbl = lower(string(s));
    catch
    end

    if contains(ylbl, "communica")
        t = "comm";
    elseif contains(ylbl, "computa")
        t = "compu";
    else
        t = "acc";
    end
end
