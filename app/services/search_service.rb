# frozen_string_literal: true

class SearchService
  SEARCH_MODELS = %w[Question Answer Comment User].freeze

  def call(query, model = nil)
    return [] if query.blank?

    if model.present?
      search_in_model(model, query)
    else
      global_search(query)
    end
  end

  private

  def search_in_model(model, query)
    ThinkingSphinx.search(query, classes: [model.constantize])
  end

  def global_search(query)
    ThinkingSphinx.search(query, classes: SEARCH_MODELS.map(&:constantize))
  end
end
