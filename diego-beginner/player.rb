class Player
  def play_turn(warrior)
    @warrior = warrior
    @previous_health ||= 20
    if warrior.feel.empty?
      if under_attack?
        @warrior.walk!
      elsif !full_health?
        @warrior.rest!
      else
        @warrior.walk!
      end
    else
      @warrior.attack!
    end
    @previous_health = @warrior.health
  end

  def full_health?
    @warrior.health == 20
  end

  def under_attack?
    @warrior.health < @previous_health
  end
end
