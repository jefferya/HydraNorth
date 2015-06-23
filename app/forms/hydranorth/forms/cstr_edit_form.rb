module Hydranorth
  module Forms
    class CstrEditForm < CstrPresenter
      include HydraEditor::Form
      self.required_fields = [:title, :creator, :subject, :trid, :language]

      # This is required so that fields_for will draw a nested form.
      # See ActionView::Helpers#nested_attributes_association?
      #   https://github.com/rails/rails/blob/a04c0619617118433db6e01b67d5d082eaaa0189/actionview/lib/action_view/helpers/form_helper.rb#L1890
      def permissions_attributes= attributes
        model.permissions_attributes= attributes
      end

    end
  end
end
