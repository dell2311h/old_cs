require "resque/tasks"

task "resque:setup" => :environment
namespace :resque do
  PIDFILE_PATH = "#{::Rails.root}/tmp/pids/resque.pid"
  desc "Start resque daemon"
  task :start => :environment do
    check_resque_running
    command ="PIDFILE=#{PIDFILE_PATH} BACKGROUND=yes QUEUE=* bundle exec rake environment resque:work"
    invoke_system_command(command)
    puts "\tResque daemon started."
  end

  desc "Stop resque daemon"
  task :stop => :environment do
    if pid_file_exists?
      command = "kill -QUIT `cat #{PIDFILE_PATH}`"
      invoke_system_command(command)
      resque_pid = File.read(PIDFILE_PATH)
      puts "\tResque daemon stopped. Process PID: #{resque_pid}"
      File.delete(PIDFILE_PATH)
      puts "\tPidfile deleted"
    else
      puts "\tNothing to stop. Resque daemon wasn't running before"
    end
  end

  desc "Restart resque daemon"
  task :restart => :environment do
    Rake::Task["resque:stop"].invoke
    Rake::Task["resque:start"].invoke
  end


  private

    def invoke_system_command command
      raise "\tCan't execute. To figure out where is error, try this command at your shell: \n #{command}" unless system command
    end

    def process_running?(pid)
      Process.getpgid(pid)
      true
    rescue Errno::ESRCH
      false
    end

    def pid_file_exists?
      File.file?(PIDFILE_PATH)
    end

    def check_resque_running
      if pid_file_exists?
        resque_pid = File.read(PIDFILE_PATH)
        raise "Resque daemon is running already. You can't run more than 1 of resque daemons at once" if rescue_running?
      end
    end

    def rescue_running?
      if pid_file_exists?
        resque_pid = File.read(PIDFILE_PATH)
        process_running?(resque_pid.to_i)
      end
    end
end

