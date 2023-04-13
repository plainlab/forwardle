# Forwardle

> Dead simple HTTP request forwarder [WIP]

## Developer guide

1. Install `asdf`

Follow instructions [here](https://asdf-vm.com/).

2. Install `erlang` & `elixir`

```sh
asdf install
```

3. Install project dependencies

```sh
mix deps.get
```

5. Migrate database & start server

```sh
mix ecto.setup
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
