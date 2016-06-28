module My
  class SharesController < MyController

    self.search_params_logic += [
      :add_access_controls_to_solr_params,
      :show_only_shared_files,
      :show_only_generic_files
    ]

    def show_only_shared_files(solr_parameters, user_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] += [
        "-" + ActiveFedora::SolrQueryBuilder.construct_query_for_rel(depositor: current_user.user_key)
      ]
    end

    def index
      super
      @selected_tab = :shared
      @selected_tab_path = sufia.dashboard_shares_path
    end

    protected

    def search_action_url *args
      sufia.dashboard_shares_url *args
    end

  end
end
