c "lib/server.ex"
{:ok, processId} = Plug.Adapters.Cowboy.http Server, []
IO.inspect(procesId)