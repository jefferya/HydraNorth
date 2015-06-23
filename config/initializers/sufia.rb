# Returns an array containing the vhost 'CoSign service' value and URL
Sufia.config do |config|

  config.fits_to_desc_mapping= {
    file_title: :title,
    file_author: :creator
  }

  config.max_days_between_audits = 7

  config.max_notifications_for_dashboard = 5

  config.cc_licenses = {
    'Attribution 4.0 International' => 'http://creativecommons.org/licenses/by/4.0/',
    'Attribution-ShareAlike 4.0 International' => 'http://creativecommons.org/licenses/by-sa/4.0/',
    'Attribution-NonCommercial 4.0 International' => 'http://creativecommons.org/licenses/by-nc/4.0/',
    'Attribution-NoDerivs 4.0 International' => 'http://creativecommons.org/licenses/by-nd/4.0/',
    'Attribution-NonCommercial-NoDerivs 4.0 International' => 'http://creativecommons.org/licenses/by-nc-nd/4.0/',
    'Attribution-NonCommercial-ShareAlike 4.0 International' => 'http://creativecommons.org/licenses/by-nc-sa/4.0/',
    'Public Domain Mark 1.0' => 'http://creativecommons.org/publicdomain/mark/1.0/',
    'CC0 1.0 Universal' => 'http://creativecommons.org/publicdomain/zero/1.0/',
    "I am required to use/link to a publisher's license" => "I am required to use/link to a publisher's license",
  }

  config.cc_licenses_reverse = Hash[*config.cc_licenses.to_a.flatten.reverse]

  config.resource_types = {
    "Book" => "Book",
    "Book Chapter" => "Book Chapter",
    "Conference\/Workshop Poster" => "Conference\/Workshop Poster",
    "Conference\/Workshop Presentation" => "Conference\/Workshop Presentation",
    "Dataset" => "Dataset", 
    "Image" => "Image",
    "Journal Article (Draft-Submitted)" => "Journal Article (Draft-Submitted)",
    "Journal Article (Published)" => "Journal Article (Published)",
    "Learning Object" => "Learning Object",
    "Report" => "Report",
    "Research Material" => "Research Material",
    "Review" => "Review",
  }

  config.resource_types_to_schema = {
    "Book" => "http://schema.org/Book",
    "Book Chapter" => "http://schema.org/Book",
    "Conference\/Workshop Poster" => "http://schema.org/CreativeWork",
    "Conference\/Workshop Presentation" => "http://schema.org/CreativeWork",
    "Dataset" => "http://schema.org/Dataset",
    "Image" => "http://schema.org/ImageObject",
    "Journal Article (Draft-Submitted)" => "http://schema.org/Article",
    "Journal Article (Published)" => "http://schema.org/Article",
    "Learning Object" => "http://schema.org/CreativeWork",
    "Report" => "http://schema.org/CreativeWork",
    "Research Material" => "http://schema.org/CreativeWork",
    "Review" => "http://schema.org/Review",
  }

   config.admin_resource_types = {
    "Book" => "Book",
    "Book Chapter" => "Book Chapter",
    "Computing Science Technical Report" => "Computing Science Technical Report",
    "Conference\/Workshop Poster" => "Conference\/Workshop Poster",
    "Conference\/Workshop Presentation" => "Conference\/Workshop Presentation",
    "Dataset" => "Dataset",
    "Image" => "Image",
    "Journal Article (Draft-Submitted)" => "Journal Article (Draft-Submitted)",
    "Journal Article (Published)" => "Journal Article (Published)",
    "Learning Object" => "Learning Object",
    "Report" => "Report",
    "Research Material" => "Research Material",
    "Review" => "Review",
    "Structural Engineering Report" => "Structural Engineering Report",
    "Thesis" => "Thesis",
  }

  config.languages = {
    "English" => "English",
    "French" => "French",
    "Spanish" => "Spanish",
    "Chinese" => "Chinese",
    "German" => "German",
    "Italian" => "Italian",
    "Russian" => "Russian",
    "Ukrainian" => "Ukrainian",
    "Japanese" => "Japanese",
    "No linguistic content" => "No linguistic content",
    "Other" => "other",
  }

  # please run rake db:seed to create the collections and restart httpd. 
  # The collection IDs will be added here
  # In production it assumes that the collections will be available in the system at the time of deposit
  # config.cstr_collection_id = ""
  # config.ser_collection_id = ""
  config.special_reports = {
    "cstr" => "Computing Science Technical Report",
    "ser" => "Structural Engineering Report",
  }
 
  config.permission_levels = {
    "Choose Access"=>"none",
    "View/Download" => "read",
    "Edit" => "edit"
  }

  config.owner_permission_levels = {
    "Edit" => "edit"
  }

  config.queue = Sufia::Resque::Queue

  # Enable displaying usage statistics in the UI
  # Defaults to FALSE
  # Requires a Google Analytics id and OAuth2 keyfile.  See README for more info
  config.analytics = true

  # Specify a Google Analytics tracking ID to gather usage statistics
  # config.google_analytics_id = 'UA-99999999-1'

  # Specify a date you wish to start collecting Google Analytic statistics for.
  # config.analytic_start_date = DateTime.new(2014,9,10)

  # Where to store tempfiles, leave blank for the system temp directory (e.g. /tmp)
  # config.temp_file_base = '/home/developer1'

  # Specify the form of hostpath to be used in Endnote exports
  # config.persistent_hostpath = 'http://localhost/files/'

  # If you have ffmpeg installed and want to transcode audio and video uncomment this line
  config.enable_ffmpeg = true

  # Sufia uses NOIDs for files and collections instead of Fedora UUIDs
  # where NOID = 10-character string and UUID = 32-character string w/ hyphens
  # config.enable_noids = true

  # Specify a different template for your repository's NOID IDs
  # config.noid_template = ".reeddeeddk"
  
  # Specify the path to the minter-state file
  config.minter_statefile = "tmp/minter-state"

  # Specify the prefix for Redis keys:
  # config.redis_namespace = "sufia"

  # Specify the path to the file characterization tool:
  # config.fits_path = "fits.sh"
  config.fits_path = "fits"

  config.enable_contact_form_delivery = true
  config.from_email = "HydraNorth Form"

  # Specify how many seconds back from the current time that we should show by default of the user's activity on the user's dashboard
  # config.activity_to_show_default_seconds_since_now = 24*60*60

  # Specify a date you wish to start collecting Google Analytic statistics for.
  # Leaving it blank will set the start date to when ever the file was uploaded by
  # NOTE: if you have always sent analytics to GA for downloads and page views leave this commented out
  # config.analytic_start_date = DateTime.new(2014,9,10)
  #
  # Method of converting ids into URIs for storage in Fedora
  # config.translate_uri_to_id = lambda { |uri| uri.to_s.split('/')[-1] }
  # config.translate_id_to_uri = lambda { |id|
  #      "#{ActiveFedora.fedora.host}#{ActiveFedora.fedora.base_path}/#{Sufia::Noid.treeify(id)}" }

  # If browse-everything has been configured, load the configs.  Otherwise, set to nil.
  begin
    if defined? BrowseEverything
      config.browse_everything = BrowseEverything.config
    else
      Rails.logger.warn "BrowseEverything is not installed"
    end
  rescue Errno::ENOENT
    config.browse_everything = nil
  end

end

Date::DATE_FORMATS[:standard] = "%m/%d/%Y"
