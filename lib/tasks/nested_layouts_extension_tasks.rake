namespace :radiant do
  namespace :extensions do
    namespace :nested_layouts do
      
      desc "Runs the migration of the Nested Layouts extension"
      task :migrate => :environment do
        puts "This extension does not affect the database. Nothing done."
      end
      
      desc "Copies public assets of the Nested Layouts to the instance public/ directory."
      task :update => :environment do
        puts "This extension has no public assets.  Nothing done."
      end  
    end
  end
end
