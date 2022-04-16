module CustomInputs
  class SmallIntegerInput < SimpleForm::Inputs::StringInput
    def initialize(*params)
      super
      input_html_options['data-integer-target'] = 'input'
      input_html_options['data-min'] = 0
      input_html_options['data-max'] = 10
      input_html_options['readonly'] = true
    end

    def input(wrapper_options)
      template.content_tag(:div, class: 'small-integer-input', 'data-controller' => 'integer') do
        super + template.content_tag(:button, '-',
                                     class: 'decrement', 'data-action' => 'integer#decrement') + + template.content_tag(
                                       :button, '+', class: 'increment', 'data-action' => 'integer#increment'
                                     )
      end
    end
  end
end
