# https://luckyframework.org/guides/frontend/html-forms#shared-components

class Shared::Field(T) < BaseComponent
  include Lucky::CatchUnpermittedAttribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String?

  def render
    label_for attribute, label_text
    tag_defaults field: attribute do |tag_builder|
      yield tag_builder
    end

    mount Shared::FieldErrors, attribute
  end

  def render
    render &.text_input
  end
end
