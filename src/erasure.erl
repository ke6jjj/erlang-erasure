-module(erasure).

-export([encode/3,
         decode/3
        ]).

-on_load(init/0).

-define(APPNAME, erasure).
-define(LIBNAME, 'erasure').

-spec encode(K :: pos_integer(), M :: pos_integer(), binary()) -> [{Index :: non_neg_integer(), TotalSize :: pos_integer(), binary()}, ...].
encode(_, _, _) ->
    not_loaded(?LINE).

-spec decode(K :: pos_integer(), M :: pos_integer(), Shards :: [{Index :: non_neg_integer(), TotalSize :: pos_integer(), binary()}, ...]) -> binary().
decode(_, _, _) ->
    not_loaded(?LINE).

init() ->
    SoName = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            case filelib:is_dir(filename:join(["..", priv])) of
                true ->
                    filename:join(["..", priv, ?LIBNAME]);
                _ ->
                    filename:join([priv, ?LIBNAME])
            end;
        Dir ->
            filename:join(Dir, ?LIBNAME)
    end,
    erlang:load_nif(SoName, 0).

not_loaded(Line) ->
    erlang:nif_error({not_loaded, [{module, ?MODULE}, {line, Line}]}).