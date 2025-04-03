function newFig = combine_figures_into_subplots(figs, axs)
% combineFiguresIntoSubplots Copies figures from a cell array into subplots of a new figure.
%
%   newFig = combineFiguresIntoSubplots(figs) takes an m-by-n cell array 'figs',
%   where each cell contains a handle to a MATLAB figure. It creates a new
%   figure 'newFig' with an m-by-n grid of axes. The entire content of
%   each figure in 'figs' (including its own subplots, legends, etc.) is
%   copied into the corresponding axes location in 'newFig'.
%
%   Input:
%       figs - An m-by-n cell array where each element is a valid figure handle.
%
%   Output:
%       newFig - Handle to the newly created figure containing the combined plots.
%
%   Example:
%       % 1. Create some example source figures with subplots
%       fig1 = figure('Name', 'Source 1');
%       subplot(1,2,1); plot(rand(10,1)); title('Sub 1.1');
%       subplot(1,2,2); scatter(rand(10,1), rand(10,1)); title('Sub 1.2');
%
%       fig2 = figure('Name', 'Source 2');
%       surf(peaks); title('Peaks Surface');
%
%       fig3 = figure('Name', 'Source 3');
%       plot(1:10, (1:10).^2); title('Square'); xlabel('X'); ylabel('Y');
%
%       fig4 = figure('Name', 'Source 4');
%       subplot(2,1,1); bar(rand(1,5)); title('Sub 4.1');
%       subplot(2,1,2); plot(cos(linspace(0, 2*pi, 50))); title('Sub 4.2');
%
%       % 2. Store handles in a cell array (e.g., 2x2)
%       myFigs = {fig1, fig2; fig3, fig4};
%
%       % 3. Combine them into a new figure
%       combinedFig = combineFiguresIntoSubplots(myFigs);
%
%       % Optional: Close original figures if not needed anymore
%       % close(fig1); close(fig2); close(fig3); close(fig4);

% --- Input Validation ---
if ~iscell(figs)
    error('Input must be a cell array of figure handles.');
end
if isempty(figs)
    warning('Input cell array is empty. Returning an empty figure.');
    newFig = figure;
    return;
end

if nargin < 2, axs = []; end

% --- Setup ---
[m, n] = size(figs); % Get grid dimensions

% Create the new figure where everything will be combined
newFig = figure('Name', 'Combined Figures from Cell Array', 'WindowState', 'maximized');

% --- Main Loop ---
for i = 1:m % Iterate through rows
    for j = 1:n % Iterate through columns

        srcFig = figs{i, j}; % Get the source figure handle

        % Validate the handle
        if isempty(srcFig) || ~ishandle(srcFig) || ~strcmp(get(srcFig, 'Type'), 'figure')
            warning('Skipping invalid or deleted figure handle at figs{%d, %d}. Creating empty placeholder.', i, j);
            % Create an empty subplot as a placeholder
            ax = subplot(m, n, (i-1)*n + j, 'Parent', newFig);
            title(ax, sprintf('Invalid Source (%d, %d)', i, j));
            axis(ax, 'off');
            continue; % Skip to the next figure
        end

        % --- Determine Target Position ---
        % Calculate the index for the subplot grid
        subplotIndex = (i-1)*n + j;

        % Create a temporary axes in the target figure using subplot
        % to easily get the desired outer position for this grid location.
        % OuterPosition includes space for labels, titles, etc.
        tempAx = subplot(m, n, subplotIndex, 'Parent', newFig);
        targetOuterPos = get(tempAx, 'OuterPosition');
        delete(tempAx); % Delete the temporary axes, we just needed its position

        % --- Find Axes in Source Figure ---
        % Find all axes objects (including potentially legends, colorbars)
        % in the source figure. These are the objects we need to copy.
        if isempty(axs)
            srcAxes = findall(srcFig, 'Type', 'axes');
        else
            if ndims(axs)==3
                srcAxes = squeeze(axs(i, j, :));
            elseif ndims(axs) == 2
                srcAxes = squeeze(axs(i, :));
            end
            srcAxes = [srcAxes{:}];
        end

        if isempty(srcAxes)
           warning('Source figure figs{%d, %d} contains no axes objects. Creating empty placeholder.', i, j);
           ax = subplot(m, n, subplotIndex, 'Parent', newFig);
           title(ax, sprintf('Empty Source (%d, %d)', i, j));
           axis(ax, 'off');
           continue; % Skip to the next figure
        end

        sup_title = [];
        sup_xlabel = [];
        sup_ylabel = [];
        if isprop(srcFig,'Children') && isa(srcFig.Children,'matlab.graphics.layout.TiledChartLayout')

            if isprop(srcFig.Children,'Title') && ~isempty(srcFig.Children.Title)

                sup_title = srcFig.Children.Title.String;

            end

            if isprop(srcFig.Children,'XLabel') && ~isempty(srcFig.Children.XLabel)

                sup_xlabel = srcFig.Children.XLabel.String;
                
            end

            if isprop(srcFig.Children,'YLabel') && ~isempty(srcFig.Children.YLabel)

                sup_ylabel = srcFig.Children.YLabel.String;
                
            end

        end

        sup_fig_size = size(srcAxes);
        sup_fig_mid_subs = round(sup_fig_size/2);
        % --- Copy and Reposition Each Source Axes ---
        for k = 1:numel(srcAxes)
            originalAx = srcAxes(k);

            % Get the position of the current axes RELATIVE TO THE SOURCE FIGURE.
            % Position is [left, bottom, width, height] in normalized units.
            originalPos = get(originalAx, 'Position');

            % Copy the individual axes and its children from the source figure
            % to the NEW figure.
            copiedAx = copyobj(originalAx, newFig);
            
            % [iX, iY] = ind2sub(sup_fig_size,k);
            % if ~isempty(sup_title) && iY == sup_fig_mid_subs(end) && iX == 1
            % 
            %     title(copiedAx, sup_title);
            % 
            % end
            % 
            % if ~isempty(sup_ylabel) && iX == sup_fig_mid_subs(1) && iY == 1
            % 
            %     ylabel(copiedAx, sup_ylabel);
            % 
            % end
            % 
            % if ~isempty(sup_xlabel) && iX == sup_fig_size(1) && iY == sup_fig_mid_subs(end)
            % 
            %     xlabel(copiedAx, sup_xlabel);
            % 
            % end



            % --- Calculate New Position ---
            % Scale and shift the original normalized position to fit within
            % the target subplot's 'OuterPosition' boundaries in the new figure.
            % new_x = target_left + original_left * target_width
            % new_y = target_bottom + original_bottom * target_height
            % new_w = original_width * target_width
            % new_h = original_height * target_height
            newX = targetOuterPos(1) + originalPos(1) * targetOuterPos(3);
            newY = targetOuterPos(2) + originalPos(2) * targetOuterPos(4);
            newW = originalPos(3) * targetOuterPos(3);
            newH = originalPos(4) * targetOuterPos(4);

            % Set the position of the COPIED axes in the NEW figure.
            set(copiedAx, 'Position', [newX, newY, newW, newH]);
        end % End loop through source axes




    end % End loop columns (j)
end % End loop rows (i)

% Optional: Add an overall title to the new figure
% sgtitle(newFig, 'Combined Figure Display');

end % End function