require 'rubygems'
require 'pry'
require 'bundler'
Bundler.setup

require 'sinatra'

get "/" do
  lines = read_file("public/complex.logo")
  grid_size = lines.shift.to_i
  grid = grid_setup(grid_size)

  location = [grid_size/2, grid_size/2]

  create_logo(lines, grid, location)

  @total = grid

  erb :total
end

def grid_setup(size)
  grid = []

  size.times do |x|
    grid << Array.new(size, ".")
  end

  grid[size/2][size/2] = "X"

  grid
end

def read_file(file)
  lines = []
  File.open(file).each do |line|
    lines << line.chomp unless line.chomp.empty?
  end
  lines
end

def create_logo(lines, grid, location)
  orientation = 90

  lines.each do |line|
    orientation, location = command(line, orientation, location, grid)
  end
end

def command(line, orientation, location, grid)
  command = line.split
  case command[0]
  when "RT"
    orientation = orientation + command[1].to_i
  when "LT"
    orientation = orientation - command[1].to_i
  when "FD"
    location = draw_line(orientation, command[1].to_i, grid, location)
  when "BK"
    location = draw_line(orientation, command[1].to_i, grid, location, true)
  when "REPEAT"
    num = command[1].to_i
    sentence = command[3..command.length-2]
    num_of_commands = sentence.length/2
    num.times do
      num_of_commands.times do |x|
        orientation, location = command(sentence[0 + (x*2)] + ' ' + sentence[1 + (x*2)], orientation, location, grid)
      end
    end
  end
  return orientation, location
end

def draw_line(degree, units, grid, location, backward = false)
  x = location[0]
  y = location[1]

  degree = set_degrees(degree)

  case degree
  when 0
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y][x-unit] = "X"
    end
    if backward == true
      location = set_location(x+units,y)
    else
      location = set_location(x-units,y)
    end

  when 45
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y-unit][x-unit] = "X"
    end
    if backward == true
      location = set_location(x+units,y+units)
    else
      location = set_location(x-units,y-units)
    end

  when 90
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y-unit][x] = "X"
    end
    if backward == true
      location = set_location(x,y+units)
    else
      location = set_location(x,y-units)
    end

  when 135
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y-unit][x+unit] = "X"
    end
    if backward == true
      location = set_location(x-units,y+units)
    else
      location = set_location(x+units,y-units)
    end

  when 180
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y][x+unit] = "X"
    end
    if backward == true
      location = set_location(x-units,y)
    else
      location = set_location(x+units,y)
    end

  when 225
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y+unit][x+unit] = "X"
    end
    if backward == true
      location = set_location(x-units,y-units)
    else
      location = set_location(x+units,y+units)
    end

  when 270
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y+unit][x] = "X"
    end
    if backward == true
      location = set_location(x,y-units)
    else
      location = set_location(x,y+units)
    end

  when 315
    (0..units).each do |unit|
      if backward == true
        unit = unit*-1
      end
      grid[y+unit][x-unit] = "X"
    end
    if backward == true
      location = set_location(x+units,y-units)
    else
      location = set_location(x-units,y+units)
    end

  end
  location
end

def set_location(x,y)
  [x, y]
end

def set_degrees(degree)
  if degree >= 360
    degree - 360
  elsif degree < 0
    degree + 360
  else
    degree
  end
end

