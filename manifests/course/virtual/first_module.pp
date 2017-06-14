class classroom::course::virtual::first_module (
  $session_id         = $classroom::params::session_id,
  $role               = $classroom::params::role,
  $offline            = $classroom::params::offline,
  $jvm_tuning_profile = $classroom::params::jvm_tuning_profile,
) inherits classroom::params {
  class { 'classroom::virtual':
    offline            => $offline,
    jvm_tuning_profile => $jvm_tuning_profile,
  }

  # Classroom for First Module
  if $role == 'master' {

    class { 'puppetfactory':
      plugins          => [ "Certificates", "Classification", "ConsoleUser", "Docker", "Logs", "ShellUser", "UserEnvironment" ],
      puppetcode       => $classroom::params::testdir,
      modulepath       => 'readwrite',
      usersuffix       => $classroom::params::usersuffix,
      session          => $session_id,
      privileged       => false,
    }

  }
}
