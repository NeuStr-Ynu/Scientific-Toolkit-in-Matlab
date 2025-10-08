function [xf, yf] = data2fig(ax, x, y)
%DATA2FIG 将数据坐标（data coordinates）转换为图像坐标（figure coordinates）
%
% [xf, yf] = DATA2FIG(ax, x, y) 将指定坐标轴 ax 中的数据点 (x, y)
% 映射到归一化的 figure 坐标系中，返回 xf 和 yf。
%
% 输入参数：
%   ax - axes 对象，数据点所在的坐标轴句柄
%   x  - 数据 x 坐标，可以为标量或数组
%   y  - 数据 y 坐标，大小需与 x 匹配
%
% 输出参数：
%   xf - 转换后的 x 坐标，单位为 figure 的归一化坐标（0 到 1 之间）
%   yf - 转换后的 y 坐标，单位为 figure 的归一化坐标（0 到 1 之间）
%
% 示例用法：
%   fig = figure;
%   ax = axes(fig);
%   plot(ax, 0:10, (0:10).^2);
%   [xf, yf] = data2fig(ax, 5, 25); % 将点 (5, 25) 转换为 figure 坐标
%
% 用途：
%   常用于在 figure 的特定位置添加注释、文本框、标记等不依赖坐标轴变换的元素。

    % 获取坐标轴的边界和位置
    ax_pos = ax.Position;       % [left bottom width height] in normalized figure units
    ax_xlim = ax.XLim;
    ax_ylim = ax.YLim;
    
    % 将数据点映射到 axes 内部的归一化坐标
    x_norm = (x - ax_xlim(1)) / (ax_xlim(2) - ax_xlim(1));
    y_norm = (y - ax_ylim(1)) / (ax_ylim(2) - ax_ylim(1));
    
    % 将 axes 内部归一化坐标映射到 figure 坐标
    xf = ax_pos(1) + x_norm * ax_pos(3);
    yf = ax_pos(2) + y_norm * ax_pos(4);
end