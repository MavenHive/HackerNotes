module Plug
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    field :title, type: String
    field :description, type: String
    field :url, type: String
    field :html, type: String
    field :height, type: String
    field :width, type: String

    field :thumbnail, type: String
    field :thumbnail_height, type: String
    field :thumbnail_width, type: String


    belongs_to :user
    # validates :title, presence: true, on: :create
    # validates :description, presence: true, on: :create
    validates :url, presence: true, uniqueness: true, format: URI::regexp(%w(http https))

    default_scope limit(10)
    before_create :fetch_attributes
    embedded_in :repository
  end

  def fetch_attributes
    embedly_obj = EmbedlyService.new(self.url)
    self.set_attributes(embedly_obj) unless embedly_obj.nil?
  end

  def set_attributes(embedly_obj)
    self.common_attributes(embedly_obj).each do |attr|
      self[attr] = embedly_obj[attr] if embedly_obj[attr]
    end
  end

  def common_attributes(embedly_obj)
    self.attribute_names.map(&:to_sym) & embedly_obj.marshal_dump.keys
  end
end
