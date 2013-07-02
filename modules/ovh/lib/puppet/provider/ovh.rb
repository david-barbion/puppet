#!/usr/bin/env ruby
require 'rest_client'
require 'digest/sha1'
require 'puppet/provider'
require 'json'

class Puppet::Provider::Ovh < Puppet::Provider

  desc "Manage OVH services"

  @@url = 'https://api.ovh.com/1.0'

  def create_request(method, query, body='')
    debug "create_request"
    now = Time.now.to_i.to_s
    basesig = @resource[:applicationsecret]+'+'+@resource[:consumerkey]+'+'+method.upcase!+'+'+query+'+'+body+'+'+now
    debug "signature: #{basesig}"
    return '$1$' + Digest::SHA1.hexdigest(basesig);
  end

  # base get/post queries
  def get(query)
      query = @@url+query
      debug "get #{query}"
      now = Time.now.to_i.to_s
      sig = self.create_request('get', query)
      JSON.parse(RestClient.get(query, :accept              => :json, 
                            :'X-Ovh-Application' => @resource[:applicationkey], 
                            :'X-Ovh-Timestamp'   => now, 
                            :'X-Ovh-Signature'   => sig, 
                            :'X-Ovh-Consumer'    => @resource[:consumerkey]))
  end
  def post(query,jsondata=nil)
      query = @@url+query
      debug "post #{query}"
      now = Time.now.to_i.to_s
      sig = self.create_request('post', query,JSON.dump(jsondata))
      RestClient.post(query, JSON.dump(jsondata), :content_type        => :json, 
                                                             :accept              => :json, 
                                                             :'X-Ovh-Application' => @resource[:applicationkey], 
                                                             :'X-Ovh-Timestamp'   => now,
                                                             :'X-Ovh-Signature'   => sig, 
                                                             :'X-Ovh-Consumer'    => @resource[:consumerkey])
  end
  def post(query)
      query = @@url+query
      debug "post #{query}"
      now = Time.now.to_i.to_s
      sig = self.create_request('post', query)
      RestClient.post(query,  {},                            :accept              => :json, 
                                                             :'X-Ovh-Application' => @resource[:applicationkey], 
                                                             :'X-Ovh-Timestamp'   => now,
                                                             :'X-Ovh-Signature'   => sig, 
                                                             :'X-Ovh-Consumer'    => @resource[:consumerkey])
  end
  def put(query,jsondata)
      query = @@url+query
      debug "put #{query}"
      now = Time.now.to_i.to_s
      sig = self.create_request('put', query, JSON.dump(jsondata))
      RestClient.put(query, JSON.dump(jsondata), :content_type        => :json, 
                                                 :accept              => :json, 
                                                 :'X-Ovh-Application' => @resource[:applicationkey], 
                                                 :'X-Ovh-Timestamp'   => now,
                                                 :'X-Ovh-Signature'   => sig, 
                                                 :'X-Ovh-Consumer'    => @resource[:consumerkey])
  end
  def delete(query)
      query = @@url+query
      debug "delete #{query}"
      now = Time.now.to_i.to_s
      sig = self.create_request('delete', query)
      RestClient.delete(query, :accept              => :json, 
                            :'X-Ovh-Application' => @resource[:applicationkey], 
                            :'X-Ovh-Timestamp'   => now, 
                            :'X-Ovh-Signature'   => sig, 
                            :'X-Ovh-Consumer'    => @resource[:consumerkey])
  end


  # Basic SDK

  def get_domains
    debug "get_domains"
    query = "/domains"
    self.get(query)
  end


  def find_resource_id(name, type='')
    query = "/domains/#{@resource[:servicename]}/resolutions?fieldType=#{type}&subDomain=#{name}"
    self.get(query)
  end

  def find_resource
    debug "find_resource"
    begin
      res = self.find_resource_id(@resource[:name], @resource[:fieldtype])
      if res.count > 1
        raise "more than one id matches"
      elsif res.count == 0
        false
      else
        self.get("/domains/#{@resource[:servicename]}/resolutions/#{res[0]}")
      end
    rescue Exception => e
      raise "could not manage domain #{@resource[:servicename]}: #{e.message}"
    end
  end

  def create_resource
    debug "create_resource"
    query = "/domains/#{@resource[:servicename]}/resolutions"
    self.post(query, @record)
  end

  def update_resource
    debug "update_resource"
    query = "/domains/#{@resource[:servicename]}/resolutions/#{@record["id"]}"
    self.put(query, @record)
  end

  def delete_resource
    debug "delete_resource"
    query = "/domains/#{@resource[:servicename]}/resolutions/#{@record["id"]}"
    self.delete(query)
  end

  def refresh_domain
    debug "refresh_domain"
    query = "/domains/#{@resource[:servicename]}/refresh"
    self.post(query)
  end
end

