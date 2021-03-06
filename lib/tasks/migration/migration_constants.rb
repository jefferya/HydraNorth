module MigrationConstants
  # three different rake tasks depend on this constant being defined, instead of magically assuming its available,
  # lets make it an actual dependency that is required on each of the rake task needing it
  NS = {
        "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:foxml"=>"info:fedora/fedora-system:def/foxml#",
        "xmlns:audit"=>"info:fedora/fedora-system:def/audit#",
        "xmlns:dc"=>"http://purl.org/dc/elements/1.1/",
        "xmlns:dcterms"=>"http://purl.org/dc/terms/",
        "xmlns:georss"=>"http://www.georss.org/georss/",
        "xmlns:oai_dc"=>"http://www.openarchives.org/OAI/2.0/oai_dc/",
        "xmlns:ualid"=>"http://terms.library.ualberta.ca/id/",
        "xmlns:ualterms"=>"http://terms.library.ualberta.ca",
        "xmlns:ualthesis"=>"http://terms.library.ualberta.ca/thesis/",
        "xmlns:ualplace"=>"http://terms.library.ualberta.ca/place/",
        "xmlns:ualname"=>"http://terms.library.ualberta.ca/name/",
        "xmlns:ualtitle"=>"http://terms.library.ualberta.ca/title/",
        "xmlns:ualdate"=>"http://terms.library.ualberta.ca/date/",
        "xmlns:ualsubj"=>"http://terms.library.ualberta.ca/subject/",
        "xmlns:ualrole"=>"http://terms.library.ualberta.ca/role/",
        "memberof"=>"info:fedora/fedora-system:def/relations-external#",
        "hasmodel"=>"info:fedora/fedora-system:def/model#",
        "xmlns:rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "userns"=>"http://era.library.ualberta.ca/schema/definitions.xsd#",
        "xmlns:marcrel"=>"http://id.loc.gov/vocabulary/relators",
        "xmlns:vivo"=>"http://vivoweb.org/ontology/core",
        "xmlns:bibo"=>"http://purl.org/ontology/bibo/",
        "dcterms" => "http://purl.org/dc/terms/"
    }
end
