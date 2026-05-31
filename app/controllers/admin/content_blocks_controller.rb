# frozen_string_literal: true

module Admin
  class ContentBlocksController < BaseController
    before_action :set_content_block, only: %i[ edit update destroy ]

    def index
      @content_blocks = ContentBlock.trust.order(:position)
    end

    def new
      @content_block = ContentBlock.new(section: :trust, position: next_position, active: true)
    end

    def create
      @content_block = ContentBlock.new(content_block_params)

      if @content_block.save
        redirect_to admin_content_blocks_path, notice: "Blok eklendi."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @content_block.update(content_block_params)
        redirect_to admin_content_blocks_path, notice: "Blok güncellendi."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @content_block.destroy
      redirect_to admin_content_blocks_path, notice: "Blok silindi."
    end

    private

    def set_content_block
      @content_block = ContentBlock.find(params[:id])
    end

    def content_block_params
      params.require(:content_block).permit(:title, :body, :icon, :position, :active)
    end

    def next_position
      (ContentBlock.trust.maximum(:position) || -1) + 1
    end
  end
end
