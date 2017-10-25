class CounterController < WebsocketRails::BaseController  
  def hello
    Game.increment_counter(:player_num,1)
    @count = Game.first.player_num
    WebsocketRails[:updates].trigger(:update, @count)
  end

  def goodbye
    Game.decrement_counter(:player_num,1)
    @count = Game.first.player_num
    WebsocketRails[:updates].trigger(:update, @count)
  end

  def ready
    # game = current_user.games.last
    puts "I'm ready!"
    current_user = User.find(session[:user_id])
    join = current_user.joins.last
    # binding.pry
    join.win = true
    join.save
    game = join.game
    puts game.joins.where(win:true).size
    if game.joins.where(win:true).count == game.player_num
      puts "we all ready!"
      WebsocketRails[:updates].trigger(:start,"Start Game!")
    end
  end
end  