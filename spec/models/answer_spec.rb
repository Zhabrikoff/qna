# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to :question }
  it { should have_many :links }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it { should have_many_attached(:files) }
end
