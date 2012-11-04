require 'pry'
class Player
  def play_turn(warrior)
    @warrior = warrior
    @direction ||= has_captives_behind? ? :backward : :forward
    @previous_health ||= 20

    if warrior.feel(@direction).empty?
      if under_attack? && dying?
        @warrior.walk!(:backward)
        @enemies_left = true
      elsif can_shoot?
        @warrior.shoot!
      elsif under_attack? || full_health? || !enemies_left?
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
        @warrior.attack!(@direction)
      end
    end
    @previous_health = @warrior.health
  end

  def full_health?
    @warrior.health == 20
  end

  def enemies_left?
    vision = @warrior.look
    vision.delete_if {|s| !s.enemy?}
    @enemies_left || vision.any?
  end

  def targeted?
    vision = @warrior.look
    vision.delete_if {|s| !s.enemy?}
    if vision.any?
      case vision.first.unit.name
      when "Wizard"
        true
      when "Archer"
        true
      else
        false
      end
    else
      false
    end
  end

  def under_attack?
    @warrior.health < @previous_health
  end

  def dying?
    @warrior.health < 5
  end

  def can_shoot?
    vision = @warrior.look
    vision.delete_if {|s| s.empty? || s.stairs? || s.wall?}
    if vision.any?
      case vision.first.unit.name
      when "Wizard"
        true
      when "Archer"
        dying? #&& targeted?
      else
        false
      end
    else
      false
    end
  end

  def has_captives_behind?
    vision = @warrior.look(:backward)
    vision.delete_if {|s| !s.captive?}
    vision.size > 0
  end
end
