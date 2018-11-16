# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc "Generates the user manual/documentation"
task :compile_doc do
  doc_path = Rails.root.join("doc")
  img_path = doc_path.join("img")
  index_path = doc_path.join("index.adoc")
  out = Rails.root.join("public")
  out_file = out.join("documentation.html")

  Asciidoctor.convert_file(index_path.to_s, header_footer: true)
  `bundle exec asciidoctor -o #{out_file} #{index_path}`
  FileUtils.cp_r img_path.to_s, out.to_s

  puts "documentation compiled and created at: #{out_file}"
end
