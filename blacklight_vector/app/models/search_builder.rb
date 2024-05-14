# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  self.default_processor_chain += [:add_custom_data_to_query]

  def add_custom_data_to_query(solr_parameters)
    Rails.logger.info("QUERY is #{blacklight_params[:q]}")
    solr_parameters[:custom] = blacklight_params[:user_value]
  end
end
