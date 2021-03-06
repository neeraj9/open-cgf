%%%-------------------------------------------------------------------
%%% File    : open-cgf_app.erl
%%% Author  : Bruce Fitzsimons <bruce@fitzsimons.org>
%%% Description :
%%%
%%% Created : 27 Jan 2008 by Bruce Fitzsimons <bruce@fitzsimons.org>
%%%
%%% Copyright 2008 Bruce Fitzsimons
%%%
%%% This file is part of open-cgf.
%%%
%%% open-cgf is free software: you can redistribute it and/or modify
%%% it under the terms of the GNU General Public License version 2 as
%%% published by the Free Software Foundation.
%%%
%%% open-cgf is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%% GNU General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with open-cgf.  If not, see <http://www.gnu.org/licenses/>.
%%%-------------------------------------------------------------------
-module('open-cgf_app').

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% Application callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start(Type, StartArgs) -> {ok, Pid} |
%%                                     {ok, Pid, State} |
%%                                     {error, Reason}
%% Description: This function is called whenever an application
%% is started using application:start/1,2, and should start the processes
%% of the application. If the application is structured according to the
%% OTP design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%--------------------------------------------------------------------
start(_Type, StartArgs) ->
    case 'open-cgf_config':get_item({'open-cgf', syslog}, ip_port_or_none, none) of
	{ok, none} -> error_logger:info_msg("Syslogging disabled");
	{ok, {IP, Port}} ->
	    'open-cgf_logger':add_handler(syslog, {IP, Port})
    end,
    case 'open-cgf_config':get_item({'open-cgf', log_dir}, none, none) of %% TODO validation of string or none
        {ok, none} -> error_logger:info_msg("Errors will not be logged to a file");
        {ok, Dir} ->
            Filename = filename:join([Dir, "open-cgf.log"]),
	    error_logger:info_msg("Logging errors/messages to ~s",[Filename]),
            ok = error_logger:logfile({open, filename:join([Dir, "open-cgf.log"])})
    end,
    case 'open-cgf_sup':start_link(StartArgs) of
	{ok, Pid} ->
	    'open-cgf_state':inc_restart_counter(), %% both TCP and UDP servers do this so if either restarts it is noticable
	    {ok, Pid};
	Error ->
	    Error
    end.

%%--------------------------------------------------------------------
%% Function: stop(State) -> void()
%% Description: This function is called whenever an application
%% has stopped. It is intended to be the opposite of Module:start/2 and
%% should do any necessary cleaning up. The return value is ignored.
%%--------------------------------------------------------------------
stop(_State) ->
    error_logger:logfile(close),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
