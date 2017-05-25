namespace :pawn do
  task :make => :environment do
    puts "=== CREATE PAWN ==="
    print "  Enter management key: "
    mgmt_key_value = $stdin.gets.chomp
    mgmt_key = ManagementKey.find_by(value: mgmt_key_value)
    if mgmt_key && mgmt_key.space
      print "  Enter pawn name: "
      pawn_name = $stdin.gets.chomp

      pawn = Pawn.create!(name: pawn_name, space: mgmt_key.space)
      puts "---> Pawn created: #{pawn.inspect}"
    end
    puts "=== END CREATE PAWN ==="
  end

  namespace :keys do
    task :gen => :environment do
      puts "=== CREATE PAWN KEY ==="
      print "  Enter pawn id: "
      pawn_id = $stdin.gets.chomp
      pawn = Pawn.find(pawn_id)
      if pawn
        print "  Enter mgmt key: "
        mgmt_key_value = $stdin.gets.chomp
        mgmt_key = ManagementKey.find_by(value: mgmt_key_value)
        if mgmt_key
          puts "---> Creating pawn key..."
          pawn_key = PawnKey.create(pawn: pawn)
          puts
          puts
          puts
          puts "PAWN KEY VALUE: '#{pawn_key.value}'"
          puts
          puts "[THIS VALUE WILL NOT BE DISPLAYED AGAIN]"
        else
          puts "---> Management key must be valid/active"
        end
      else
        puts "---> Pawn ID must be valid..."
      end
      puts "=== END CREATE PAWN KEY ==="
    end
  end
end
