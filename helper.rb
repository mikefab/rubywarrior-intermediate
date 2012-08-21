module Helper

  ENEMIES   = ["Wizard", "Archer", "Thick Sludge",  "Sludge"]
  HENEMIES  = {"Wizard" => 1, "Archer" => 1, "Thick Sludge" => 1, "Sludge" => 1}
  DIRECTIONS = [:forward, :backward,  :left, :right]

	def Helper.do_walk(warrior, direction = :forward)
		warrior.walk!(direction)
	end

  def Helper.meanies?(warrior) #reports if there are any evil entities in the room
    ENEMIES.each do |e|
      index = warrior.listen.index{|i| i.to_s == e} 
      return warrior.direction_of(warrior.listen[index]) if index
    end  
    nil
  end

  def Helper.ticking_friendlies?(warrior)
    index = warrior.listen.index{|i| i.ticking?}
    return warrior.direction_of(warrior.listen[index]) if index 
  end
  
  def Helper.friendlies?(warrior)
    index = warrior.listen.index{|i| i.to_s == "Captive"} 
    return warrior.direction_of(warrior.listen[index]) if index
  end

  def Helper.hugged?(warrior)
    DIRECTIONS.each do |d|
      if warrior.feel(d).to_s.match("Captive")
				print "FOUND one in #{d}\n"
        return d
      end
    end
    nil
  end

  def Helper.hunt(warrior,meanies, friendlies, crowded, hugged, sanctuary)#Enemies remain around. Hunt finds and kills the
		print "#{warrior.health} HHH\n"
    unless warrior.feel.stairs?
      if !friendlies.nil? &&  warrior.feel(friendlies).to_s.match(/Captive/)
        warrior.rescue!(friendlies)
      else
        unless Helper.fit?(warrior)
					warrior.rest!
					#warrior.walk!(sanctuary)
				else
					if crowded
						warrior.attack!(crowded)
					elsif hugged
						warrior.rescue!(hugged)
					else
						warrior.walk!(meanies)
  				end
				end
			end
		else
      warrior.walk!(delay(warrior))
    end
  end

  def Helper.delay(warrior)
    DIRECTIONS.each do |d|
      next if d.match(/forward/)
      return d if warrior.feel(d).to_s.match(/nothing/)
    end
  end

  def Helper.crowded?(warrior)
    DIRECTIONS.each do |d|
      if HENEMIES[warrior.feel(d).to_s] 
        return d
      end
    end
    nil
  end

  def Helper.sanctuary?(warrior, movementsl)	#Sancuary is where no one can harm warrior
    DIRECTIONS.each do |d|
      return d if warrior.feel(d).to_s.match(/nothing/) && d !=  warrior.direction_of_stairs #&& d != movements.last
    end
    false 
  end

  def Helper.fit?(warrior)
    if warrior.health >= 4
      return true
    else
      return false
    end 
  end

  def Helper.siege?(warrior,health)
    (warrior.health<health) ? true : false
  end

	def Helper.should_detonate?(warrior)
		print "#{warrior.look[0].to_s} #{warrior.look[1]}\n"
		return 1 if HENEMIES[warrior.look[0].to_s] and HENEMIES[warrior.look[1].to_s]
		nil
	end

  def Helper.shoot?(warrior)
#    warrior.look.size.times do |t|
#      [:forward,:backward,:left,:right].each do |dir|
#        ENEMIES.each do |enemy|
#          if warrior.look(dir)[t].to_s == "#{enemy}"
#            flag = 1
#            t.times do |t2|
#              flag = 0 unless  warrior.look(dir)[t-(t2+1)].to_s == "nothing"
#            end
#            return dir if flag == 1
#          end
#        end
#      end
#    end
   return nil
  end
end
