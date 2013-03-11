class Repository
  include Mongoid::Document
  field :name, type: String
  field :owner, type: String
  field :full_name, type: String
  field :description, type: String
  field :watchers, type: Integer
  field :forks, type: Integer

  after_create :create_from_service

  def create_from_service
    create_blog_from_service
  end

  def create_blog_from_service
    blogs = BlogService.fetch(self.name)
    blogs.each do |blog|
      self.blogs.create(blog.attributes)
    end
  end

  embeds_many :subscription_services
  embeds_many :blogs
  embeds_many :tips
  embeds_many :slides
  embeds_many :qnas
  embeds_many :books
  embeds_many :noteworthies
  embeds_many :screencasts
end
