require "encoding_lib_worker"
namespace :encoding_worker do

desc "Run worker"

task :run => [:environment] do
  worker = EncodingLib::Worker.new
  worker.run
end
end