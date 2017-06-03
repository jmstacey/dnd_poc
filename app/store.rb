require 'grand_central'
require 'grand_central/versioned_store'
require "ostruct"

class AppState < GrandCentral::Model
  attributes(
    :counter, :data, :visible_data
  )
end

class TransientKVStore
  # Declare a class with getters and setters so we can debug state changes
  # but without the overhead of a versioned store and full model copies
  def initialize
    @internal_hash = {}
  end

  def set(key, value)
    @internal_hash[key] = value
    puts "[Store] KV Set: #{key}=#{value}"
  end

  def get(key)
    @internal_hash[key]
  end
end

module Actions
  include GrandCentral

  IncreaseCounter = Action.with_attributes(:amount)
  UpdateVisibleData = Action.with_attributes(:new_data)
  # DecreaseCounter = Action.with_attributes(:counter)
end
# Example: https://gist.github.com/jgaskins/bee43e458252c29e0bd3

class Store
  include Inesita::Injection

  attr_reader :app, :transient

  def initialize
    loaded_app_state = load_app_state()

    init_app_store_with(loaded_app_state)
    init_render_on_dispatch_hooks

    init_transient_store()
  end

  def load_app_state
    AppState.new(
      counter: 0, # Integer
      data: Array.new, # Ruby Array
      visible_data: JSON.parse('[{"id":1}, {"id":2, "children":[{"id":3}, {"id":4}, {"id":5, "children":[{"id":6}, {"id":7}, {"id":8}]}, {"id":9}, {"id":10}]}, {"id":11}, {"id":12}]') # Ruby Array
    )
  end

  def init_app_store_with(initial_app_state)
    @app = GrandCentral::VersionedStore.new(initial_app_state) do |state, action|
      puts "[Store] Action Received: #{action}"
      case action
      when Actions::UpdateVisibleData
        state.update(visible_data: action.new_data)
      when Actions::IncreaseCounter
        state.update(counter: state.counter + action.amount)
      when :decrease_counter
        state.update(counter: state.counter - 1)
      else
        state
      end
    end
  end

  # Automaticlly trigger Inesita render on every app state change so we don't have to explicitly render from components
  def init_render_on_dispatch_hooks
    @app.on_dispatch do |old_state, new_state|
      render! unless old_state.equal?(new_state)
    end
  end

  def init_transient_store
    @transient = TransientKVStore.new
  end
end
