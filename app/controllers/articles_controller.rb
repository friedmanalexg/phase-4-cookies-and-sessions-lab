class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::NotAuthorized, with: :not_authorized

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    session[:page_views] ||= 0
    session[:page_views] +=1
    if session[:page_views] <= 3
      render json: article, status: :ok
    else
      render json: { error: "Maximum pageview limit reached"}, status: 401
    end
    
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
  # def not_authorized
  #   render json: { error: "Maximum pageview limit reached"}, status: 401
  # end

end
