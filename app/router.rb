class Router
  include Inesita::Router

  def routes
    route '/', to: Home
    route '/outline', to: Outline #, on_enter: -> { store.app.dispatch :set_screen_is_clean }
  end
end
