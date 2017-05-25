namespace :city do
  # task :make ...
  namespace :keys do
    task :gen => :environment do
      puts "=== CREATE MANAGEMENT KEY ==="
      space = Space.first
      puts "---> Making new mgmt key for space #{space.name}..."
      key = ManagementKey.create!(space: space)
      puts "---> Key #{key.id} created!"
      puts
      puts
      puts "MANAGEMENT KEY VALUE: '#{key.value}'"
      puts
      puts "[THIS VALUE WILL NOT BE DISPLAYED AGAIN]"
      puts
      puts "=== END CREATE MANAGEMENT KEY ==="
    end
  end
end
