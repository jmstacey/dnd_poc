class Counter
  include Inesita::Component

  def render
    h4 do
      text props[:header]
    end
    div class: 'input-group' do
      span class: 'input-group-btn' do
        button class: 'btn btn-default', onclick: -> { store.app.dispatch :decrease_counter } do
          text '-'
        end
      end
      input type: "text", class: "form-control", value: store.app.state.counter, disabled: true
      span class: 'input-group-btn' do
        button class: 'btn btn-default', onclick: -> { store.app.dispatch Actions::IncreaseCounter.new(1) } do
          text '+'
        end
      end
    end

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
