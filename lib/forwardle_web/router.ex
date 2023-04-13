defmodule ForwardleWeb.Router do
  import Phoenix.LiveDashboard.Router

  use ForwardleWeb, :router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ForwardleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :admin_user do
    plug ForwardleWeb.Plugs.AdminUserAuthPlug
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  # Public
  scope "/", ForwardleWeb do
    pipe_through [:browser, :not_authenticated]

    get "/signup", RegistrationController, :new, as: :signup
    post "/signup", RegistrationController, :create, as: :signup

    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
  end

  # User
  scope "/user", ForwardleWeb do
    pipe_through [:browser, :protected]

    get "/change-password", RegistrationController, :edit, as: :account
    put "/change-password", RegistrationController, :update, as: :account
    get "/account", UserController, :show, as: :account
    get "/logout", SessionController, :delete, as: :logout
  end

  # Flows
  scope "/"  do
    pipe_through [:browser, :protected]

    get "/flows", ForwardleWeb.FlowController, :list, as: :flow
  end

  # Pages
  scope "/" do
    pipe_through [:browser]

    get "/", ForwardleWeb.PageController, :home
  end

  scope "/" do
    pipe_through [:browser, :protected, :admin_user]

    live_dashboard "/dashboard", metrics: ForwardleWeb.Telemetry, ecto_repos: [Forwardle.Repo]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:forwardle, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).

    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
