# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  self.default_processor_chain += [:add_custom_data_to_query]

  def add_custom_data_to_query(solr_parameters)
    Rails.logger.info("QUERY is #{blacklight_params[:q]}")
    return unless blacklight_params[:q].present?

    solr_parameters[:q] = "{!knn f=vector topK=10}[#{retrieve_embedding(blacklight_params[:q]).join(',')}]"
  end

  def retrieve_embedding(input)
    Rails.cache.fetch("huggingface/#{input}") do
      client = HuggingFace::InferenceApi.new(api_token: ENV['HUGGING_FACE_API_TOKEN'])
      client.embedding(input: [input]).first
    end
  end
end
