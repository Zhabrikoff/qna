# frozen_string_literal: true

class SearchController < ApplicationController
  skip_authorization_check

  def search
    @data = SearchService.new.call(params[:query], params[:model])
    @grouped_results = @data.group_by(&:class)
  end
end
