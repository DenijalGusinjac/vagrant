$App = 'vagrant.dev'
$AppLocation = "/var/www/html/${App}"

# execute 'apt-get update'
exec { 'apt-update':                    
  command => '/usr/bin/apt-get update'  
}


# install apache2 package
package { 'apache2':
  require => Exec['apt-update'],        
  ensure => installed,
}

#git clone
package{'git':
  ensure => present,
}
vcsrepo{$AppLocation:
  ensure => present,
  provider=>git,
  source => 'https://github.com/DenijalGusinjac/vagrant.git',
}

# ensure apache2 service is running
service { 'apache2':
  ensure => running,
}

# install mysql-server package
package { 'mysql-server':
  require => Exec['apt-update'],        
  ensure => installed,
}

# ensure mysql service is running
service { 'mysql':
  ensure => running,
}

# install php5 package
package { 'php5':
  require => Exec['apt-update'],        
  ensure => installed,
}


file { '/var/www/html/index.php':
  ensure => file,
  content => '<?php echo "User: " . $_SERVER[REMOTE_ADDR];	?>',  
  require => Package['apache2'],      
}

file { '/var/www/html/index.html':
  ensure => file,
  content => 'test', 
  require => Package['apache2'],      
}

file { '/var/www/html/.htaccess':
  ensure => file,
  content => 'ewriteEngine on
    RewriteBase /
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^ index.php [L]',    # phpinfo code
  require => Package['apache2'],        # require 'apache2' package before creating
} 