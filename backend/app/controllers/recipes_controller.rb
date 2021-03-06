class RecipesController < ApplicationController
  def index
    render json: {recipes: Recipe.all.sort.map{ |recipe| format_recipe(recipe) }}
  end

  def submit
    # find user from the user id then 
    @recipe = Recipe.new(recipe_params)
    @user = User.find(recipe_params[:user_id])
    @recipe.user = @user
    if @recipe.valid?
      @recipe.save!
      render json: {recipes: Recipe.all.sort.map{ |recipe| format_recipe(recipe) }}
    else
      render json: {recipes: Recipe.all.sort.map{ |recipe| format_recipe(recipe) }, error: 'oWo uh oh! your recipe is invalid 🥺👉👈'}
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    # @recipe.update(status: recipe_params[:status])
    @recipe.update(recipe_params)
    render json: {recipes: Recipe.all.sort.map { |recipe| format_recipe(recipe)}}
  end

  def destroy
    Recipe.destroy(params[:id])
    render json: {recipes: Recipe.all.sort.map{ |recipe| format_recipe(recipe) }}
  end

  private
    def recipe_params
      params.require(:recipe).permit(:name, :link, :status, :notes, :user_id, :img_url, :is_favorited)
    end

    def format_recipe(recipe)
      {
        submittedBy: recipe.user.username,
        name: recipe.name,
        status: recipe.status,
        notes: recipe.notes,
        id: recipe.id,
        imgUrl: recipe.img_url,
        link: recipe.link,
        isFavorited: recipe.is_favorited
      }
    end
end