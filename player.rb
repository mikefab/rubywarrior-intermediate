class Player
require "Helper"

  def play_turn(warrior)
    @track_bound ||= {}
    @movements ||= []
    @health ||=  warrior.health
		@binding_record ||= Hash.new
    diff      =  @health - warrior.health 
    fit       =  Helper.fit?(warrior)
    @crowded = Helper.crowded?(warrior)#indicates if an enemy is next to warrior from any side
    meanies = Helper.meanies?(warrior)
    friendlies = Helper.friendlies?(warrior) #return direction of a friendly
    ticking_friendlies = Helper.ticking_friendlies?(warrior)
    @hugged    = Helper.hugged?(warrior)
    sanctuary = Helper.sanctuary?(warrior, @movements)
    goal      = warrior.direction_of_stairs
    should_detonate = Helper.should_detonate?(warrior)
		if warrior.feel.stairs? 
      if meanies.nil? && friendlies.nil?	#No entities left, go to door.
				Helper.do_walk(warrior)
      else 					#kill or help remaining entities. 
				if @hugged
					 warrior.rescue!(@hugged)
				elsif @crowded
					warrior.attack!(@crowded)
				else
					Helper.do_walk(warrior, Helper.delay(warrior))
				end
      end
    else
      if fit
        if ticking_friendlies
          if @hugged 
            if warrior.feel(@hugged).ticking?
              warrior.rescue!(@hugged) 
            else 
							Helper.do_walk(warrior, ticking_friendlies)
            end
          elsif @crowded
            if warrior.feel(:forward).enemy?
							print "#{should_detonate} llll\n"
              if should_detonate
								warrior.detonate!
							elsif @binding_record.size <=1
								unless @binding_record[:left]
                	@binding_record[:left] = 1
									warrior.bind!(:left) 
								else @binding_record[:right]			
									@binding_record[:right] = 1
									warrior.bind!(:right) 
								end
							else
                warrior.attack!(:forward)
              end
            else
							Helper.do_walk(warrior, ticking_friendlies)
            end  
          else
						Helper.do_walk(warrior, ticking_friendlies)
          end
        elsif friendlies
          if @hugged 
              warrior.rescue!(@hugged) 
          elsif @crowded
            if diff >= 100  then
              warrior.bind!(@crowded)
            else
              warrior.attack!(@crowded)
            end
          else
            warrior.walk!(friendlies)
          end
          
        elsif meanies
					print "#{@crowded} MEANIES!\n"
          Helper.hunt(warrior, meanies, friendlies, @crowded, @hugged, sanctuary) #Enemies remain around. Hunt finds and kills them
        else
          warrior.walk!(goal)
        end
      else	#if not fit
				print "UUUUUU\n"
        if @crowded
					print "CCCCCCCC\n"
          if sanctuary
						print "SSSSSS\n"
            warrior.walk!(sanctuary)
            @movements << sanctuary
          else
            warrior.attack!(@crowded)
          end
        else
          warrior.rest!
        end
      end 
    end
    @health = warrior.health
  end
end
