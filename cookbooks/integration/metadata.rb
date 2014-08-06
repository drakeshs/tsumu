name             'integration'
maintainer       'Qwinixtech'
maintainer_email 'japgil@qwinixtech.com'
license          'All rights reserved'
description      'Installs/Configures integration'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'jenkins'
depends 'apt'
depends 'java'
depends 'nginx'