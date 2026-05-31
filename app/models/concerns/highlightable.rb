# frozen_string_literal: true

module Highlightable
  extend ActiveSupport::Concern

  included do
    scope :featured_now, -> {
      active.where(featured: true)
            .where("featured_until IS NULL OR featured_until > ?", Time.current)
            .order(updated_at: :desc)
    }

    scope :new_arrival_now, -> {
      active.where(new_arrival: true)
            .where("new_arrival_until IS NULL OR new_arrival_until > ?", Time.current)
            .order(created_at: :desc)
    }
  end

  def featured_active?
    featured? && (featured_until.nil? || featured_until > Time.current)
  end

  def new_arrival_active?
    new_arrival? && (new_arrival_until.nil? || new_arrival_until > Time.current)
  end
end
