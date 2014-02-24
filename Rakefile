require "rspec/core/rake_task"
require "bundler/gem_tasks"
require "br_danfe"

task default: :spec
RSpec::Core::RakeTask.new

I18n.locale = "pt-BR"

desc "Open an irb session preloaded BrDanfe classes"
task :console do
  sh "irb -rubygems -I lib -r br_danfe.rb"
end

desc "Generate a pdf from a xml file"
task :pdf_from, :source_xml, :target_pdf do |t, args|
  xml_file = args[:source_xml]
  pdf_file = args[:target_pdf] || xml_file + ".pdf"

  puts "\n\n\n"
  puts "Reading #{xml_file}"
  puts "Creating #{pdf_file}"

  BrDanfe.generate("#{pdf_file}", "#{xml_file}")

  puts "File #{pdf_file} created successfully\n\n\n"
end

namespace :spec do
  namespace :fixtures do
    desc "Recreate all pdfs fixtures. Use this task always that output pdf format is changed."
    task :recreate_pdfs do
      Dir["spec/fixtures/nfe*.xml"].each do |f|
        puts "Recreating #{f}.fixture.pdf"
        BrDanfe.generate("#{f}.fixture.pdf", "#{f}")
      end
    end
  end
end
