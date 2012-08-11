class Player
require "Helper"

  def play_turn(warrior)
    @track_bound ||= {}
    @movements ||= []
    @health ||=  warrior.health
    diff      =  @health - warrior.health 
    fit       =  Helper.fit?(warrior)
    crowded = Helper.crowded?(warrior)#indicates if an enemy is next to warrior from any side
    meanies = Helper.meanies?(warrior)
    friendlies = Helper.friendlies?(warrior) #return direction of a friendly
    ticking_friendlies = Helper.ticking_friendlies?(warrior)
    hugged    = Helper.hugged?(warrior)
    sanctuary = Helper.sanctuary?(warrior, @movements)
    goal      = warrior.direction_of_stairs
   

    if warrior.feel.stairs? 
      if meanies.nil? && friendlies.nil?
       warrior.walk!
      else 
        warrior.walk!(Helper.delay(warrior))
      end
    else
      if fit 
        if ticking_friendlies
          if hugged 
            if warrior.feel(hugged).ticking?
              warrior.rescue!(hugged) 
            else 
              warrior.walk!(ticking_friendlies)
            end
          elsif crowded
            if warrior.feel(:forward).enemy?
              if diff >= 1  then
                print "BBBB\n"
                warrior.bind!(:left)
              else
                warrior.attack!(:forward)
              end
            else
              warrior.walk!(ticking_friendlies)
            end  
          else
            warrior.walk!(ticking_friendlies)
          end
          
        elsif friendlies
          if hugged 
              warrior.rescue!(hugged) 
          elsif crowded
            if diff >= 100  then
              warrior.bind!(crowded)
            else
              warrior.attack!(crowded)
            end
          else
            warrior.walk!(friendlies)
          end
          
        elsif meanies
          Helper.hunt(warrior, meanies, friendlies) #Enemies remain around. Hunt finds and kills them
        else
          warrior.walk!(goal)
        end
      else
        if crowded
          if sanctuary
            warrior.walk!(sanctuary)
            @movements << sanctuary
          else
            warrior.attack!(crowded)
          end
        else
          warrior.rest!
        end
      end 
    end
    @health = warrior.health
  end
end
