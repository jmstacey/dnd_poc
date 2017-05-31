class DevTimeTravel
  include Inesita::Component

  def render
    div class: 'dev-time-travel-input-group' do
      span class: 'input-group-btn' do
        button class: 'btn btn-default', onclick: -> { store.app.rollback } do
          text 'Undo'
        end
      end
      input type: "text", class: "form-control", value: "#{store.app.current_version + 1} / #{store.app.total_versions}", disabled: true
      span class: 'input-group-btn' do
        button class: 'btn btn-default', onclick: -> { store.app.redo } do
          text 'Redo'
        end
      end
    end
  end
end
