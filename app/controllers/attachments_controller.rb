# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :find_attachment, only: :destroy

  def destroy
    @attachment.purge
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
