require 'pry'
class Player
  def play_turn(warrior)
    @warrior = warrior
    @direction ||= :forward
    @previous_health ||= 20
    if warrior.feel(@direction).empty?
      if under_attack? && dying?
        @warrior.walk!(:backward)
      elsif can_shoot?
        @warrior.shoot!
      elsif under_attack? || full_health?
        @warrior.walk!(@direction)
      else
        @warrior.rest!
      end
    else
      if warrior.feel(@direction).wall?
        @warrior.pivot!
      elsif warrior.feel(@direction).captive?
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

  def can_shoot?
    vision = @warrior.look
    vision.delete_if {|s| s.empty?}
    vision.size > 0 && vision.first.unit.class == RubyWarrior::Units::Wizard
  end
end
