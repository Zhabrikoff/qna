# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GistService do
  let(:link) { 'https://gist.github.com/Zhabrikoff/534ae0062adf5d3f42494745c58ae200' }
  let(:invalid_link) { 'https://gist.github.com/Zhabrikoff/invalid_url' }

  describe 'fetching gist content' do
    it 'returns an array with the gist content' do
      expect(GistService.new(link).call).to eq ['Test gist']
    end

    it 'returns an error message for an invalid link' do
      expect(GistService.new(invalid_link).call).to eq ['Not found']
    end
  end
end
