puppet
======

Various puppet stuff

OVH Module
==========

Manage your OVH DNS with Puppet


Description
-----------

The __ovh__ module brings a new provider: __domain__. It can create, update and delete DNS records.
OVH provides a REST API, it is available here: https://api.ovh.com/.

### Initialization

For this module to work you will need:
* an application key
* an application secret
* a consumer key

To obtain the application key and application secret, go to http://www.ovh.com/cgi-bin/api/createApplication.cgi with your OVH nic handle.
The consumer key is created by following this procedure: http://www.ovh.com/fr/g934.premiers-pas-avec-l-api#creation_des_identificants.

You'll need those 3 parameters every time and for every puppet resource for managing the DNS.

### Usage


#### Type A record
```
domain { 'my-domain':
  ensure            => present,
  applicationkey    => 'xxxxxx',
  applicationsecret => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  consumerkey       => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  servicename       => 'example.com',
  provider          => 'ovh',
  fieldtype         => 'A',
  target            => '1.2.3.7',
}
```
* servicename: domain name on which to make the update
* fieldtype: type of record to create (A, AAAA, MX, NS, CNAME....)
* target: record target (ipv4 address for A, ipv6 address for AAAA, hostname for CNAME, ...)


