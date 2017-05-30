class Outline
  include Inesita::Component

  Element.expose :nestable

  def on_dd_change(container, element_changed)
    js_obj = container.nestable('serialize')
    new_data = JSON.from_object(js_obj)

    if new_data != store.app.state.visible_data
      store.app.dispatch Actions::UpdateVisibleData.new(new_data)
    end
  end

  def will_unmount
    Element['#outline'].nestable('destroy') # Deactivate plugin invalidating this outline as it should be deployed clean from the store now for one-way binding
  end

  def on_mounted
    Element['#outline'].nestable({ 'json': store.app.state.visible_data, 'callback': method(:on_dd_change).to_proc }.to_n) # #to_n converts to native javascript. Provided by opal-jquery
  end

  def render
    div class: "dd", id: "outline", hook: unhook(:will_unmount)

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
