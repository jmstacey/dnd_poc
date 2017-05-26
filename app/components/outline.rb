class Outline
  include Inesita::Component

  Element.expose :nestable

  def init
    @delegate = self
  end

  def on_dd_change(l, e)
    js_obj = Element['#outline'].nestable('serialize')
    new_data = JSON.from_object(js_obj)

    if new_data != store.app.state.visible_data
      store.app.dispatch Actions::UpdateVisibleData.new(new_data)
    end
  end

  def before_render
    Element['#outline'].nestable('destroy') # Deactivate plugin invalidating this outline as it should be deployed clean from the store now for one-way binding
  end

  def after_render
    Element['#outline'].nestable({ 'json': store.app.state.visible_data, 'callback': -> { on_dd_change(l, e) } }.to_n) # #to_n converts to native javascript. Provided by opal-jquery
    # Todo (caution): nestable binding is on real DOM and is likely to break on route changes. Consider a "terminate" equivalent to unload on other pages.
  end

  def render
    # Works w/ restored after_render hooks in commit
    div class: "dd", id: "outline"

    # Does not work--after_render is called immediately before the real DOM is patched
    # div class: "dd", id: "outline", hook: hook(:after_render)

    h4 do
      text props[:sub_header]
    end
    div class: 'input-group' do
      span class: 'input-group-btn' do
        button class: 'btn btn-default', onclick: -> { store.app.rollback } do
          text 'Undo'
        end
      end
      input type: "text", class: "form-control", value: store.app.current_version, disabled: true
      span class: 'input-group-btn' do
        button class: 'btn btn-default', onclick: -> { store.app.redo } do
          text 'Redo'
        end
      end
    end
  end

end
