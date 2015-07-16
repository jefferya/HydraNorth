module Hydranorth
  class DataversePresenter < GenericFilePresenter
    include Hydra::Presenter
    self.model_class = ::GenericFile
    # Terms is the list of fields displayed by app/views/generic_files/_show_descriptions.html.erb
    self.terms = [:title, :creator, :contributor, :subject, :resource_type, :language, :spatial, :temporal, :description, :date_created, :license, :rights, :is_version_of, :source, :related_url, :publisher]

  end
end
