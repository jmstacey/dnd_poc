require 'grand_central'
require 'grand_central/versioned_store'

class AppState < GrandCentral::Model
  attributes(
    :counter
  )
end

module Actions
  include GrandCentral

  IncreaseCounter = Action.with_attributes(:amount)
  # DecreaseCounter = Action.with_attributes(:counter)
end
# Example: https://gist.github.com/jgaskins/bee43e458252c29e0bd3

class Store < GrandCentral::VersionedStore
  include Inesita::Injection

  attr_reader :app

  def initialize
    app_state = load_app_state
    init_store_with(app_state)
    init_render_on_dispatch_hook
  end

  def load_app_state
    AppState.new(
      counter: 0
    )
  end

  def init_store_with(initial_app_state)
    @app = GrandCentral::VersionedStore.new(initial_app_state) do |state, action|
      case action
      when Actions::IncreaseCounter
        state.update(counter: state.counter + action.amount)
      when :decrease_counter
        state.update(counter: state.counter - 1)
      else
        state
      end
    end
  end

  # Automaticlly trigger Inesita render on every state change so we don't have to explicitly render from components
  def init_render_on_dispatch_hook
    @app.on_dispatch do |old_state, new_state|
      render! unless old_state.equal?(new_state)
    end
  end
end
