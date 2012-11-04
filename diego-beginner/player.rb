class Player
  def play_turn(warrior)
    @warrior = warrior
    @direction ||= :backward
    @previous_health ||= 20
    if warrior.feel(@direction).empty?
      if under_attack? && dying?
        @warrior.walk!(:backward)
      elsif under_attack? || full_health?
        @warrior.walk!(@direction)
      else
        @warrior.rest!
      end
    else
      if warrior.feel(@direction).captive?
        @warrior.rescue!(@direction)
        @direction = :forward
      else
        @warrior.attack!
      end
    end
    @previous_health = @warrior.health
  end

  def full_health?
    @warrior.health == 20
  end

  def under_attack?
    @warrior.health < @previous_health
  end

  def dying?
    @warrior.health < 7
  end
end
