require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'passanger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passanger_wagon'
require_relative 'manufactor'
require_relative 'instance_counter'
require 'pry'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def start
    puts 'Welcome to interface of railway management!'
    loop do
      commands
      print 'Print required command: '
      command = gets.chomp.to_i
      break if command.zero?
      do_command(command)
    end
  end

  private # private, because methods use only in class Main

  def commands
    puts "Available commands:
    1 - Create station.
    2 - Create train.
    3 - Route control.
    4 - Assign a train route.
    5 - Add a wagon to train.
    6 - Detach a wagon from train.
    7 - Move train.
    8 - Take seat or space in wagon.
    9 - Display list of wagons near train.
    10 - Display list of trains on station.
    0 - Exit the program. "
  end

  def show_stations
    puts 'All available stations: '
    @stations.each_with_index do |station, index|
      puts "#{index + 1} - #{station.inspect}"
    end
  end

  def show_trains
    puts 'All available trains: '
    @trains.each_with_index do |train, index|
      puts "#{index + 1} - #{train.inspect}"
    end
  end

  def show_routes
    puts 'All available routes: '
    @routes.each_with_index do |route, index|
      puts "#{index + 1} - #{route.inspect}"
    end
  end

  def show_wagons
    puts 'All available wagons: '
    @wagons.each_with_index do |wagon, index|
      puts "#{index + 1} - #{wagon.inspect}"
    end
  end

  def select_train
    train_index = gets.chomp.to_i - 1
    train = @trains[train_index]
    train
  end

  def select_wagon
    wagon_index = gets.chomp.to_i - 1
    wagon = @wagons[wagon_index]
    wagon
  end

  def do_command(number)
    case number
    when 1
      create_station
    when 2
      create_train
    when 3
      manage_route
    when 4
      train_route
    when 5
      add_wagon_to_train
    when 6
      detach_wagon_from_train
    when 7
      train_moving
    when 8
      take_space_or_seat_in_wagon
    when 9
      show_trains_and_wagons
    when 10
      trains_on_station
    end
  end

  def create_station
    puts 'Print name for station:'
    station_name = gets.chomp.to_s
    station = Station.new(station_name)
    puts "Station #{station_name} created successfully."
    @stations << station
  end

  def create_train
    puts 'Print 1 to create cargo train, 2 to create passangeг.'
    train_type = gets.chomp.to_i
    puts 'Print number for train:'
    number = gets.chomp
    if train_type == 1
      cargo_train = CargoTrain.new(number)
      @trains << cargo_train
      puts "Cargo train #{number} created successfully."
    elsif train_type == 2
      passanger_train = PassangerTrain.new(number)
      @trains << passanger_train
      puts "Passanger train #{number} created successfully."
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def manage_route
    puts "Print required command:
    1 - Create route.
    2 - Add station to existing route.
    3 - Delete station from existing route."
    action = gets.chomp.to_i
    case action
    when 1
      create_route
    when 2
      add_station
    when 3
      delete_station
    end
  end

  def create_route
    if @stations.size < 2
      puts 'To create route required at least 2 stations.'
      return
    else
      if @trains.empty?
        puts 'To create route required at least 1 train.'
        return
      else
        show_stations
        puts 'Print index of first station of route: '
        first_station = gets.chomp.to_i - 1
        puts 'Print index of last station of route:'
        last_station = gets.chomp.to_i - 1
        if last_station == first_station
          puts 'First station cant be last.'
          return
        else
          first = @stations[first_station]
          last = @stations[last_station]
          route = Route.new(first, last)
          @routes << route
          puts 'Route creates successfully.'
        end
      end
    end
  end

  def add_station
    show_stations
    puts 'Print index of station to add in route.'
    station_index = gets.chomp.to_i
    station = @stations[station_index - 1]
    show_routes
    puts 'Print index of route.'
    route_index = gets.chomp.to_i
    route = @routes[route_index - 1]
    route.add(station)
    puts "Station #{station} successfully added in route."
  end

  def delete_station
    show_stations
    puts 'Print index of station to delete from route.'
    station_index = gets.chomp.to_i
    station = @stations[station_index - 1]
    show_routes
    puts 'Print index of route.'
    route_index = gets.chomp.to_i
    route = @routes[route_index - 1]
    route.delete(station)
    puts "Station #{station} successfully deleted from route."
  end

  def train_route
    show_trains
    puts 'Print index of train: '
    train = select_train
    show_routes
    puts 'Print index of route: '
    route_index = gets.chomp.to_i - 1
    route = @routes[route_index]
    train.set_route(route)
    puts 'Route set successfully'
  end

  def add_wagon_to_train
    show_trains
    puts 'Print index of train: '
    train = select_train
    puts 'Print type of wagon 1 - cargo, 2 - passangeг: '
    wagon_type = gets.chomp.to_i
    case wagon_type
    when 1
      puts 'Print number of wagon to attach:'
      number = gets.chomp
      puts 'Print available space in wagon:'
      space = gets.chomp.to_i
      wagon = CargoWagon.new(space, number)
      train.add_wagon(wagon)
      @wagons << wagon
      puts 'Cargo wagon added successfully.'
    when 2
      puts 'Print number of wagon to attach:'
      number = gets.chomp
      puts 'Print available seats in wagon:'
      seats = gets.chomp.to_i
      wagon = PassangerWagon.new(seats, number)
      train.add_wagon(wagon)
      @wagons << wagon
      puts 'Passanger wagon added successfully.'
    end
  end

  def detach_wagon_from_train
    show_trains
    puts 'Print index of train: '
    train = select_train
    puts 'Print wagon to delete:'
    wagon = gets.chomp
    train.remove_wagon(wagon)
    puts 'Wagon detached successfully.'
  end

  def take_space_or_seat_in_wagon
    show_wagons
    puts 'Print index of wagon: '
    wagon = select_wagon
    if wagon.type == 'Cargo'
      wagon.empty_space
      puts 'Print space to take :'
      space = gets.chomp.to_i
      wagon.take_space(space)
      puts 'Space taken successfully.'
    else
      wagon.take_seat
      puts 'Place booked successfully.'
    end
  end

  def train_moving
    show_trains
    puts 'Print index of train: '
    train = select_train
    puts 'Print 1 to move forward, 2 to move back.'
    action = gets.chomp.to_i
    case action
    when 1
      train.move_forward
      puts 'Train moved forward.'
    when 2
      train.move_back
      puts 'Train moved back.'
    end
  end

  def show_trains_and_wagons
    @trains.each do |train|
      puts "Train number - #{train.number}"
      train.print_wagons
    end
  end

  def trains_on_station
    @stations.each do |station|
      puts "Station name - #{station.name}"
      station.print_trains
    end
  end
end

main = Main.new
main.start
