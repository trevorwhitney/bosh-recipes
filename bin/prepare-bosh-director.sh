#!/bin/bash

bosh upload stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3312.17
bosh upload release https://bosh.io/d/github.com/concourse/concourse?v=2.6.0
bosh upload release https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.1.1
