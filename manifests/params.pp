class classroom::params {
  # Configure NTP (and other services) to run in standalone mode
  $offline   = false

  # Default to root for gitea
  $control_owner = 'root'

  if $::osfamily == 'windows' {
    # Path to the student's working directory
    $workdir = 'C:/puppetcode'
    $testdir = 'C:/temp'
    $confdir = 'C:/ProgramData/PuppetLabs/puppet/etc'
    $factdir = 'C:/ProgramData/PuppetLabs/facter'
    $codedir = 'C:/ProgramData/PuppetLabs/code'
  }
  else {
    $workdir = '/root/puppetcode'
    $testdir = '/var/puppetcode'
    $confdir = '/etc/puppetlabs/puppet'
    $codedir = '/etc/puppetlabs/code'
    $factdir = '/etc/puppetlabs/facter'
  }

  # default user password
  $password  = '$1$Tge1IxzI$kyx2gPUvWmXwrCQrac8/m0' # puppetlabs

  # git configuration for the web-based alternative git workflow
  $usersuffix   = 'puppetlabs.vm'
  $repo_model   = 'single'
  $gitserver    = 'http://master.puppetlabs.vm:3000'

  # Default timeout for operations requiring downloads or the like
  $timeout = 600

  # Windows active directory setup parameters
  $ad_domainname           = 'CLASSROOM.local'
  $ad_netbiosdomainname    = 'CLASSROOM'
  $ad_dsrmpassword         = 'PuppetLabs1'

  # Tuning parameters for classroom master performance
  $jvm_tuning_profile = false  # Set to 'reduced' or false to disable

  # Certname and machine name from cert. Work around broken networks.
  if is_domain_name($::clientcert) {
    $full_machine_name = split($::clientcert,'[.]')
    $machine_name = $full_machine_name[0]
  }
  else {
    $machine_name = $::clientcert
  }

  # Default session ID for Puppetfactory classes
  $session_id    = '12345'

  # Default plugin list for Puppetfactory classes
  $plugin_list   = [ "Certificates", "Classification", "ConsoleUser", "Docker", "Logs", "Dashboard", "CodeManager", "Gitea", "ShellUser" ]

  # TODO: this logic is gross and should be cleaned up as soon as we transition fully to the auto provisioner.
  if dig($trusted, 'extensions', 'pp_role') {
    $role = $trusted['extensions']['pp_role'] ? {
      'training' => 'master',
      'master'   => 'master',
      'proxy'    => 'proxy',
      # intentionally fail if we get any other values since these
      # are the only roles that can autoprovision right now.
    }
  }
  else {
    $role = $::hostname ? {
      /^(localhost|master|classroom|puppetfactory)$/ => 'master',
      'proxy'                                => 'proxy',
      'adserver'                             => 'adserver',
      default                                => 'agent'
    }
  }
}
