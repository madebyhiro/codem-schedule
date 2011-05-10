desc "Generate rdoc using hanna"
task :docs do
  Bundler.with_clean_env do
    `hanna -SUpN -f html -t 'Codem Scheduler documentation' --main app/controllers/api/api_controller.rb app/controllers/api`
  end
end
