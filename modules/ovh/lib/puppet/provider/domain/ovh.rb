require 'puppet/provider/ovh'
require 'pp'

Puppet::Type.type(:domain).provide(:ovh, :parent => Puppet::Provider::Ovh) do
  desc "Manage OVH domains."

# domain { 'www':
#   provider          => 'ovh',
#   applicationkey    => 'xxxxxxx',
#   applicationsecret => 'xxxxxx',
#   customerkey       => 'xxxxxxxx',
#   servicename       => 'mydomain.com',
#   fieldtype         => 'A',
#   target            => 'xx.xx.xx.xx',
# }
# will create a new A entry www.mydomain.com with ip address xx.xx.xx.xx
#
######################"
 
  
  def create
    debug "create"
    @record = Hash.new
    @record["target"]    = @resource[:target]
    @record["ttl"]       = @resource[:ttl] if !@resource[:ttl].nil?
    @record["subDomain"] = @resource[:name] 
    @record["fieldType"] = @resource[:fieldtype]
    create_resource
  end

  def destroy
    debug "destroy"
    delete_resource
    @record.destroy
  end

  def exists?
    debug "exists?"
    @record = find_resource
  end

  def target
    debug "target"
    @record["target"] if @record.is_a?(Hash) && @record.has_key?("target")
  end

  def target= newvalue
    debug "target="
    @record["target"]=newvalue
    true
  end

  def ttl
    debug "ttl"
    @record["ttl"] if @record.is_a?(Hash) && @record.has_key?("ttl")
  end

  def ttl= newvalue
    debug "ttl="
    @record["ttl"]=newvalue
    true
  end

  def fieldtype
    debug "fieldtype"
    @record["fieldType"] if @record.is_a?(Hash) && @record.has_key?("fieldType")
  end

  def fieldtype= newvalue
    debug "fieldtype="
    @record["fieldType"]=newvalue
    true
  end

  def flush
    debug "flush"
    if @record.is_a?(Hash) && @record["id"]
      update_resource
    end
    refresh_domain
  end
end
