module Sufia
  module GenericFile
    module Metadata
      extend ActiveSupport::Concern

      included do

        property :label, predicate: ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false

        property :depositor, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/dpt"), multiple: false do |index|
          index.as :symbol, :stored_searchable
        end

        property :relative_path, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#relativePath'), multiple: false

        property :import_url, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#importUrl'), multiple: false do |index|
          index.as :symbol
        end

        property :part_of, predicate: ::RDF::DC.isPartOf
        property :resource_type, predicate: ::RDF::DC.type do |index|
          index.as :stored_searchable, :facetable
        end
        property :title, predicate: ::RDF::DC.title do |index|
          index.as :stored_searchable, :facetable
        end
        property :creator, predicate: ::RDF::DC.creator do |index|
          index.as :stored_searchable, :facetable
        end
        property :contributor, predicate: ::RDF::DC.contributor do |index|
          index.as :stored_searchable, :facetable
        end
        property :description, predicate: ::RDF::DC.description, multiple: false do |index|
          index.type :text
          index.as :stored_searchable
        end
        property :rights, predicate: ::RDF::DC.rights, multiple: false do |index|
          index.as :stored_searchable
        end
        property :date_created, predicate: ::RDF::DC.created, multiple: false do |index|
          index.as :stored_searchable
        end

        # We reserve date_uploaded for the original creation date of the record.
        # For example, when migrating data from a fedora3 repo to fedora4,
        # fedora's system created date will reflect the date when the record
        # was created in fedora4, but the date_uploaded will preserve the
        # original creation date from the old repository.
        property :date_uploaded, predicate: ::RDF::DC.dateSubmitted, multiple: false do |index|
          index.type :date
          index.as :stored_sortable
        end

        property :date_modified, predicate: ::RDF::DC.modified, multiple: false do |index|
          index.type :date
          index.as :stored_sortable
        end
        property :subject, predicate: ::RDF::DC.subject do |index|
          index.as :stored_searchable, :facetable
        end

        property :language, predicate: ::RDF::DC.language, multiple: false do |index|
          index.as :stored_searchable, :facetable
        end
        property :related_url, predicate: ::RDF::DC.relation, multiple: false do |index|
          index.as :stored_searchable
        end
        property :source, predicate: ::RDF::DC.source, multiple: false do |index|
          index.as :stored_searchable
        end

        # TODO: Move this somewhere more appropriate
        begin
          LocalAuthority.register_vocabulary(self, "subject", "lc_subjects")
          LocalAuthority.register_vocabulary(self, "language", "lexvo_languages")
          LocalAuthority.register_vocabulary(self, "tag", "lc_genres")
        rescue
          puts "tables for vocabularies missing"
        end
      end

    end
  end
end