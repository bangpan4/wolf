class CounterController < WebsocketRails::BaseController
  @@roles_setting = {1=>[0],
                     2=>[0,1],
                     3=>[0,1,2],
                     4=>[0,1,2,0]} 
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
      roles = @@roles_setting[game.player_num]
      roles = roles.shuffle
      joins = game.joins
      joins.each do |join|
        join.role = roles.pop()
        join.save
      end
      hoster = Random.rand(game.player_num)
      @user = game.users.find(hoster+1)
      puts @user
      WebsocketRails[:updates].trigger(:start, @user)
    end
  end

  def pick_players
    puts data.class
    user = User.find(session[:user_id])
    game = user.games.last
    # user_ids = data.collect{|d| d["value"]}
    # binding.pry
    @usernames = data.collect{|d| game.users.find(d["value"].to_i).name }
    # puts usernames
    WebsocketRails[:updates].trigger(:players,@usernames)
  end

  def vote
    user = User.find(session[:id])
    join = user.joins.last
    game = join.game
    game.vote_num += 1
    if message != nil
      join.vote = message
      join.save
    end
    if game.vote_num == game.player_num
      agree = game.joins.where(vote:true).size
      disagree = game.joins.where(vote:false).size
      if agree > disagree
        return WebsocketRails[:updates].trigger(:vote_result, true)
      end
    end

  end
end  