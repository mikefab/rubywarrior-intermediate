class Player
require "Helper"

  def play_turn(warrior)
    @movements ||= []
    @health ||=  warrior.health
    diff      =  @health - warrior.health 
    fit       =  Helper.fit?(warrior)
    crowded = Helper.crowded?(warrior)
    meanies = Helper.meanies?(warrior)
    friendlies = Helper.friendlies?(warrior) #return direction of a friendly
    hugged    = Helper.hugged?(warrior)
    sanctuary = Helper.sanctuary?(warrior, @movements)
    goal      = warrior.direction_of_stairs

    if warrior.feel.stairs? 
      warrior.walk!(Helper.delay(warrior))
    else
      if fit 
        if crowded
          if diff >= 2  then
            warrior.bind!(crowded)
          else
            warrior.attack!(crowded)
          end
        elsif meanies
          Helper.hunt(warrior, meanies, friendlies)
        elsif friendlies
          if hugged 
            warrior.rescue!(hugged)
          else
            warrior.walk!(friendles)
          end
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
