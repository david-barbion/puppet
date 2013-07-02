Puppet::Type.newtype(:domain) do
  @doc = 'Manage OVH domains.'
  ensurable

  newparam(:name, :namevar=>true) do
    desc "The name of the domain."
  end

  newparam(:applicationkey) do
    desc "The application key"
    newvalues(/^\S+$/)
  end

  newparam(:applicationsecret) do
    desc "The application secret"
    newvalues(/^\S+$/)
  end

  newparam(:consumerkey) do
    desc "The consumer key"
    newvalues(/^\S+$/)
  end

  newparam(:servicename) do
    desc "The domain on which to make a modification"
    newvalues(/^\S+$/)
  end

  newproperty(:fieldtype) do
    desc "The type of record to create"
    newvalue(:A)
    newvalue(:AAAA)
    newvalue(:CNAME)
    newvalue(:DKIM)
    newvalue(:LOC)
    newvalue(:MC)
    newvalue(:NAPT)
    newvalue(:NS)
    newvalue(:PTR)
    newvalue(:SPF)
    newvalue(:SRV)
    newvalue(:SSHFP)
    newvalue(:TXT)
  end

  newproperty(:target) do
    desc "The target, ie the ip address or cname"
    newvalue(/^\S+$/)
  end
 
  newproperty(:ttl) do
    desc "The TTL"
    newvalue(/^\d+$/)
  end
end
