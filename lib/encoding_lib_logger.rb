module EncodingLib

  class Logger

    def self.log text
      self.instance.log Time::now.to_s + "\n" + text + "\n\n\n"
    end

    def self.instance
      @@instance = self.new if @@instance.nil?

      @@instance
    end

    def log text
      @log.puts text
    end

    def initialize
      log_path = Rails.root.to_s + '/log/encoding.log'
      p log_path
      @log = File.open log_path, 'a'

    end

    def Logger.finalize(id)
        @log.close unless @log.nil?
    end

    private
      @@instance = nil

  end


end