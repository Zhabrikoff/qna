# frozen_string_literal: true

class GistService
  def initialize(url, client = default_client)
    @url = url
    @client = client
    @gist = load_gist
  end

  def call
    return ['Not found'] if @gist.nil? || @gist.errors&.any?

    @gist.files.map { |_, file| file[:content] }
  end

  private

  def gist_id
    @url.split('/').last
  end

  def load_gist
    @client.gist(gist_id)
  rescue Octokit::NotFound
    nil
  end

  def default_client
    Octokit::Client.new
  end
end
