require 'rubygems'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'rexml/document'

module PeHydra

  class Query
    attr_reader :session_token

    def initialize(login_id, password, base_url=nil)
      @base_url = base_url || 'http://23.21.180.62/HydraOnline/HydraService.svc'
      login(login_id, password)
    end

    def login(login=nil, password=nil)
      xml = Nokogiri::XML::Builder.new do |q|
        q.User {
          q.LoginId  login
          q.Password password
        }
      end.to_xml

      response = request_send(:login, xml)
      @session_token = response.css('SessionToken').text
      {
        :status => response.css('StatusCode').text,
        :message => response.css('StatusMessage').text,
        :session_token => response.css('SessionToken').text
      }
    end

    def create_project(name)
      xml = Nokogiri::XML::Builder.new do |q|
        q.Project {
          q.Name name
        }
      end.to_xml
      response = request_send(:add_project, xml)
      {
        :id => response.css('Id').text,
        :name => response.css('Name').text,
        :created_at => response.css('Created').text
      }
    end

    def project_list
      response = request_send(:projects, nil)
      list = []
      project_list = response.css('ArrayOfProject Project')
      project_list.each do |project|
        obj = {}
        fields = project.css('*')
        fields.each do |field|
          obj[field.name.underscore.to_sym] = field.text
        end
        list << obj
      end
      list
    end

    def create_media(name, path, project_id)
      xml = Nokogiri::XML::Builder.new do |q|
        q.Media {
          q.Name name
          q.RemoteURL path unless path.nil?
        }
      end.to_xml
      response = request_send(:add_media, xml, {:project_id => project_id})
      media = {}
      response.css('Media *').each do |field|
        media[field.name.underscore.to_sym] = field.text
      end
      media
    end

    def add_audio(path, params)
      #audio = File.open(path, 'rb'){ |file| file.read }
      #query = build_query(:add_audio, params)
      #query[:request].body = audio
      #query[:request].add_field "Content-Type", "application/octet-stream"
      #response = Net::HTTP.new(query[:url].host, query[:url].port).start { |http|
      #  http.request(query[:request])
      #}
      #response.body

      # FIX ME!!! :)
      url = "#{@base_url}/#{@session_token}/#{params[:project_id]}/#{params[:media_id]}/audio"
      response = `curl -F 'media=@#{path}' #{url}`
      result = response.match(/<string xmlns.*>(OK)<\/string>$/)
      result.nil? ? response : result[1]
    end

    def media_list(project_id)
      response = request_send(:media, nil,{:project_id => project_id})
      list = []
      media_list = response.css('ArrayOfMedia Media')
      media_list.each do |media|
        obj = {}
        fields = media.css('*')
        fields.each do |field|
          obj[field.name.underscore.to_sym] = field.text
        end
        list << obj
      end
      list
    end

    def sync(project_id)
      response = request_send(:sync, nil,{:project_id => project_id})
      groups = []
      groups_list = response.css('SyncedClipGroups SyncedClipGroup')
      groups_list.each do |group|
        current_group = []
        clip_list = group.css('SyncedClip')
        clip_list.each do |clip|
          obj = {}
          fields = clip.css('*')
          fields.each do |field|
            obj[field.name.underscore.to_sym] = field.text
          end
          current_group << obj
        end
        groups << current_group
      end
      groups
    end

    private

    def build_query(action, params = {})
      case action
      when :login
        url = "#{@base_url}/login"
        request = Net::HTTP::Post.new(url)
      when :add_project
        url = "#{@base_url}/#{@session_token}/projects"
        request = Net::HTTP::Post.new(url)
      when :projects
        url = "#{@base_url}/#{@session_token}/projects"
        request = Net::HTTP::Get.new(url)
      when :add_media
        url = "#{@base_url}/#{@session_token}/#{params[:project_id]}/media"
        request = Net::HTTP::Post.new(url)
      when :add_audio
        url = "#{@base_url}/#{@session_token}/#{params[:project_id]}/#{params[:media_id]}/audio"
        request = Net::HTTP::Post.new(url)
      when :media
        url = "#{@base_url}/#{@session_token}/#{params[:project_id]}/media"
        request = Net::HTTP::Get.new(url)
      when :sync
        url = "#{@base_url}/#{@session_token}/#{params[:project_id]}/sync"
        request = Net::HTTP::Get.new(url)
      else
        url = @base_url
        request = Net::HTTP::Get.new(url)
      end
      {
        :url => URI.parse(URI.encode(url)),
        :request => request
      }
    end


    def request_send(action, xml, params = {})
      query = build_query(action, params)
      query[:request].body = xml unless xml.nil?
      query[:request].add_field "Content-Type", "application/xml"
      http = Net::HTTP.new(query[:url].host, query[:url].port)
      http.read_timeout = 600
      response = http.start { |net|
        net.request(query[:request])
      }
      output = Nokogiri::XML(response.body)
    end

  end
end
