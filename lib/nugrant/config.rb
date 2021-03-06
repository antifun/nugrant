require 'rbconfig'

module Nugrant
  class Config
    DEFAULT_PARAMS_FILENAME = ".vagrantuser"
    DEFAULT_PARAMS_FILETYPE = "yml"

    attr :params_filename, true
    attr :params_filetype, true

    def self.user_base_path()
      File.expand_path("~")
    end

    def self.system_base_path()
      if Config.on_windows?
        return File.expand_path(ENV['PROGRAMDATA'] || ENV['ALLUSERSPROFILE'])
      end

      "/etc"
    end

    def self.on_windows?()
      (RbConfig::CONFIG['host_os'].downcase =~ /mswin|mingw|cygwin/) != nil
    end

    def initialize(options = {})
      options.delete_if { |key, value| value == nil }

      @params_filename = options.fetch(:params_filename, DEFAULT_PARAMS_FILENAME)
      @params_filetype = options.fetch(:params_filetype, DEFAULT_PARAMS_FILETYPE)

      @project_params_path = options.fetch(:project_params_path, nil)
      @user_params_path = options.fetch(:user_params_path, nil)
      @system_params_path = options.fetch(:system_params_path, nil)
    end

    def project_params_path()
      File.expand_path(@project_params_path || "./#{@params_filename}")
    end

    def user_params_path()
      File.expand_path(@user_params_path || "#{Config.user_base_path()}/#{@params_filename}")
    end

    def system_params_path()
      File.expand_path(@system_params_path || "#{Config.system_base_path()}/#{@params_filename}")
    end
  end
end
