class NavBar
  include Inesita::Component

  def render
    nav class: 'navbar navbar-default' do
      div class: 'container' do
        div class: 'navbar-header' do
          span class: 'navbar-brand' do
            text 'tbdgtd'
          end
          ul class: 'nav navbar-nav' do
            li class: "#{"active" if router.current_url?(:home)}" do
              a href: router.url_for(:home) do
                text 'Home'
              end
            end
            li class: "#{"active" if router.current_url?(:outline)}" do
              a href: router.url_for(:outline) do
                text 'Outline'
              end
            end
          end
        end
      end
    end
  end
end
