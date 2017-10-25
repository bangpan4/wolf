class GamesController < ApplicationController
  def show
  	@game = Game.find_by_id(params[:id])
  	if !@game
  		flash[:errors] = ["Room can not be found!"]
  		return redirect_to "/home"
  	end
  	@users = @game.users
  end

  def create
  	game = Game.create(player_num:params[:player_num])
  	game.users << current_user

  	redirect_to "/games/#{game.id}"
  end

  def join
  	game = Game.find_by_id(params[:room_num])
  	# if game and !game.user_ids.include?(session[:user_id])
  		game.users << current_user
  	# end
  	redirect_to "/games/#{params[:room_num]}"
  end

  def search_join
  	empty = 100
  	games = Game.includes(:joins).all
  	games.each do |game|
  		if game.player_num > game.joins.count
  			if game.player_num - game.joins.count < empty
  				empty = game.player_num - game.joins.count
  				id = game.id
  			end
  		end
  	end
  	if id
	  	game = Game.find_by_id(id)
	  	game.users << current_user
	  	return redirect_to "/games/#{id}"
	else
		flash[:errors] = ["There is no game joinable"]
		redirect_to '/home'
	end
  end

  def ready
  	game = Game.find_by_id(params[:id])
  	if game
  		join = game.joins.find_by(user:current_user)
  		if join
	  		join.win = true
	  		join.save
	  	end
	  	ready = true
	  	game.joins.each do |join|
	  		ready = ready and join.win
	  	end
	end
  end

  def destroy
  	join = current_user.games.find_by_id(params[:id])
  	if join
  		if join.game.joins.count == 1
  			join.game.destroy
  		end
  		join.destroy
  	end
  	redirect_to "/home"
  end
end
