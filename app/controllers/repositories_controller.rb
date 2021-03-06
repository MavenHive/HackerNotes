class RepositoriesController < ApplicationController

  def search
    @g_repos = GithubService.new.search(params[:q])
  end

  def show
    owner, name = request.url.split('/')[3], request.url.split('/')[4]
    @repo = GithubService.new.fetch(owner, name)
    popuplate_resources
  end

  def show_resources
    owner, name = request.url.split('/')[3], request.url.split('/')[4]
    @repo = GithubService.new.fetch(owner, name)
    @resources = @repo.send(params[:resource]).page params[:page]
  end

  def create_note
    @repo = Repository.find(params[:id].keys.first)
    resource_type = params[:resource]
    @note = @repo.send(resource_type).new(url: params[:url], user: current_user)
    if @note.save
      flash[:notice] = "#{resource_type.singularize.capitalize} added!"
      redirect_to show_repo_path({ owner: @repo.owner, name: @repo.name })
    else
      flash[:alert] = "Please resolve following errors and retry"
      popuplate_resources
      render :show
    end
  end

  private
  def popuplate_resources
    @videos = @repo.videos.limit(10)
    @tweeters = @repo.tweeters.limit(10)
    @subs_services = @repo.subscription_services.limit(10)
    @blogs = @repo.blogs.limit(8)
    @tips = @repo.tips.limit(10)
    @slides = @repo.slides.limit(10)
    @qnas = @repo.qnas.limit(8)
    @noteworthies = @repo.noteworthies.limit(8)
    @screencasts = @repo.screencasts.limit(10)
  end
end
