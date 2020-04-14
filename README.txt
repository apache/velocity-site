 ----
 The Apache Velocity Project
 ----
 dev@velocity.apache.org

The Apache Velocity Site
========================

Introduction
------------

 The Apache Velocity Site is what you get when you visit
 http://velocity.apache.org/ (our homepage). It is the envelope site for all Apache
 Velocity sub projects.

 In short: This svn repository is only interesting for you if you

 a) want to re-create the Apache Velocity site on your local computer or intranet.

 b) are an Apache Velocity committer and want to update the site. 


Building the Site
-----------------

 Apache Velocity uses Apache Maven 2 to build the site.

 It requires at least Maven 2.0.5 to build, Maven 2.0.6 is recommended.

 The site consists of multiple modules: The Site itself and some
 helpers that must be installed in your local Maven repository. These
 extensions are currently not present in the remote Maven
 repositories, so if you do not install them, the site build itself
 will fail.


Checking the Site module out of the Velocity Source Code Repository
===================================================================

 The site is available from
 http://svn.apache.org/repos/asf/velocity/site/ (The Apache Velocity
 Site repository). You need a Subversion client installed to download
 the site source code onto your computer.



Create the Apache Velocity Site Helper modules
----------------------------------------------

 To build the site, you need the helper modules installed locally. 

 The helper modules have been organized as a Maven reactor build. You
 can install them by running "mvn" from the "tools" sub-directory.

 You need to install these only once unless the dependencies of the
 site have changed which should only happen very rarely.


Create the Apache Velocity Site
-------------------------------

 To build the site, enter the "site" directory and run "mvn" (the
 default goal here is "site-post" which generates the site and also
 installs a few extra files (e.g. the download.cgi script for
 automatic mirror selection).

 If you want to re-create the site locally, you can now enter "mvn
 site:run" and point a web browser at "localhost:8080".


Deploy the Apache Velocity Site
-------------------------------

 What you see is (almost) what you get. While the site builds using
 stock Apache Maven 2.0.6 and also all plugins can be built and used,
 the full functionality of what you see depends of a few patches to
 Maven Doxia and the site and changes plugins.

 It is therefore recommended that you do not deploy the site from
 your local computer but log onto velocity.zones.apache.org (as a 
 committer, you can get an account here by just asking on the PMC
 list) and run the following commands:

 newgrp velocity (this will open a new shell)
 /export/home/velocity/bin/build_velocity_site.sh

 This will check out the latest version of the site into a staging
 directory, build it and deploy it to velocity.apache.org. You must
 have a local Maven settings file in your home directory, though
 (typically in ~/.m2/settings.xml):

[...]
<servers>
  <server>
    <id>velocity.apache.org</id>
    <username>{your apache user id}</username>
  </server>
</servers>
[...]

 The patches required to Doxia and the plugins can be reviewed by
 running the following commands on velocity.zones.apache.org

 ( cd /export/home/velocity/scratch/maven-2/doxia/doxia ; svn diff )
 ( cd /export/home/velocity/scratch/maven-2/doxia/doxia-sitetools ; svn diff )
 ( cd /export/home/velocity/scratch/maven-2/plugins ; svn diff )

 The various patches are open at the Maven bug tracker as MNG-2874,
 MCHANGES-67, MCHANGES-66, DOXIA-91, DOXIA-78.
 

Troubleshooting
---------------

 When building the site, you might get one or more error messages like this:

[INFO] ------------------------------------------------------------------------
[ERROR] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] The skin does not exist: Unable to download the artifact from any repository

Try downloading the file manually from the project website.

Then, install it using the command:
    mvn install:install-file -DgroupId=org.apache.velocity -DartifactId=velocity-site-skin \
        -Dversion=1.0.0 -Dpackaging=jar -Dfile=/path/to/file


  org.apache.velocity:velocity-site-skin:jar:1.0.0

 or

Missing:
----------
1) org.apache.velocity:doxia-velocity-renderer:jar:0.0.1

  Try downloading the file manually from the project website.

  Then, install it using the command:
      mvn install:install-file -DgroupId=org.apache.velocity -DartifactId=doxia-velocity-renderer \
          -Dversion=0.0.1 -Dpackaging=jar -Dfile=/path/to/file

  Path to dependency:
        1) org.apache.velocity:velocity-site:jar:1.0.0
        2) org.apache.velocity:doxia-velocity-renderer:jar:0.0.1


 Both messages mean that you neglected to install the helper
 modules. Please go to the directory where you found this README and
 run "mvn". Afterwards the site should build fine.

 An error message like this:

 [ERROR] BUILD ERROR
 [INFO] ------------------------------------------------------------------------
 [INFO] Internal error in the plugin manager executing goal 'org.apache.maven.plugins:maven-site-plugin:2.0-SNAPSHOT:run': 
         Unable to find the mojo 'org.apache.maven.plugins:maven-site-plugin:2.0-SNAPSHOT:run'
         in the plugin 'org.apache.maven.plugins:maven-site-plugin'

 means that you are probably using Apache Maven 2.0.4 and either forgot
 to add the workaround described above when trying to build the site or
 forgot to remove the extensions as described above when trying to execute
 site:run or site:deploy.


Questions and contact
---------------------

 If you have questions about the Apache Velocity Site building
 process, please ask the Velocity developers on the Velocity
 Developers mailing list at <dev@velocity.apache.org>.

