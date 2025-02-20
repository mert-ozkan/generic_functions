classdef Timer < matlab.mixin.Copyable  % Inherits copy functionality
    % This class provides a simple timer functionality, similar to tic/toc, but
    % with the ability to record multiple lapses and control output verbosity.
    % MOz, Feb 25
    properties (SetAccess = protected) % Properties that can be set only within the class
        t0 % Start time of the timer
        tF  % Stop time of the timer
        tN = [] % Array to store lapse times
    end

    properties (Dependent) % Dependent properties (calculated on the fly)
        duration % Formatted duration string
        intervals % for lapses, to be developed
    end

    properties (Dependent, Access = private) % Dependent, private properties
        raw_duration % Raw duration as a duration object
    end

    properties (Access = private) % Private properties (internal use)
        isInitiated = false % Flag indicating if the timer has started
        isTerminated = false % Flag indicating if the timer has stopped
        isSilent = false % Flag to control output messages
    end

    methods % Methods of the Timer class
        function self = Timer(isSilent) % Constructor
            % Creates a Timer object.
            % Optional input: isSilent (logical) - if true, suppresses output.
            if nargin > 0, self.isSilent = isSilent; end % Set silence flag if provided
        end

        function varargout = start(self, varargin) % Start the timer
            
            if self.isInitiated && ~self.isTerminated
                warning("The existing timer is being reset!");
            end

            self.t0 = datetime("now"); % Record the current time
            self.isInitiated = true; % Set initiation flag
            self.isTerminated = false; % Reset termination flag

            if nargout == 0, varargout = {}; 
            elseif nargout == 1, varargout{1} = self;
            else, error("Too many output arguments!")
            end

            if nargin > 1, fprintf(varargin{:}); end
        end

        function varargout = stop(self, varargin) % Stop the timer

            if self.isInitiated % Check if timer was started
                self.tF = datetime("now"); % Record the stop time
                self.isTerminated = true; % Set termination flag
            else
                warning("No timers were initiated. Ignoring.") % Warning if timer wasn't started
            end

            if nargout == 0, varargout = {}; 
            elseif nargout == 1, varargout{1} = self;
            else, error("Too many output arguments!")
            end

            if nargin > 1, fprintf(varargin{:}); end
        end

        function varargout = lapse(self, varargin) % Record a lapse time
            if nargin == 1, varargin{1} = ''; end
            if self.isInitiated || ~self.isTerminated % Check if timer is running
                self.tN(end+1) = datetime("now"); % Record lapse time
            else
                warning("No timers were initiated. Ignoring.") % Warning if timer wasn't started
            end

            if nargout == 0, varargout = {}; 
            elseif nargout == 1, varargout{1} = self;
            else, error("Too many output arguments!")
            end

            if nargin > 1, fprintf(varargin{:}); end
        end

        function d = get.raw_duration(self) % Get raw duration
            % Calculates the raw duration as a duration object.
            d = self.tF - self.t0; % Duration = stop time - start time
        end

        function d = get.duration(self) % Get formatted duration string
            % Returns a formatted string representing the duration.
            rd = self.raw_duration; % Get the raw duration
            spec = ' Elapsed time is '; % Start of the output string

            if days(rd) >= 1 % Check for days
                ds = floor(days(rd)); % Extract number of whole days
                rd = rd - days(ds); % Subtract the days from the raw duration
                spec = spec + string(ds) + ' days '; % Add days to output string
            end
            if hours(rd) >= 1 % Check for hours
                hs = floor(hours(rd)); % Extract number of whole hours
                rd = rd - hours(hs); % Subtract the hours
                spec = spec + string(hs) + ' hours '; % Add hours to output string
            end
            if minutes(rd) >= 1 % Check for minutes
                ms = floor(minutes(rd)); % Extract minutes
                rd = rd - minutes(ms); % Subtract minutes
                spec = spec + string(ms) + ' minutes '; % Add minutes to output string
            end
            if seconds(rd) >= 1 % Check for seconds
                ss = floor(seconds(rd)); % Extract seconds
                rd = rd - seconds(ss); % Subtract seconds
                spec = spec + string(ss) + ' seconds '; % Add seconds to output string
            end
            mls = round(milliseconds(rd)); % Calculate and round milliseconds
            if mls > 1, spec = spec + string(mls) + ' milliseconds'; end % Add milliseconds if greater than 1
            if ~self.isSilent
                spec = spec + '.\n'; 
                fprintf(spec); 
            end % Display the output if not silent
            d = self.raw_duration; % Return the raw duration (as a duration object)
        end


    end

end