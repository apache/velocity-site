Note: the branch trunk is obsolete. Please use the main branch.

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

 In short: This Git repository is only interesting for you if you

 a) want to re-create the Apache Velocity site on your local computer or intranet.

 b) are an Apache Velocity committer/contributor and want to update the site. 


Building the Site
-----------------

 Apache Velocity uses [Apache Content Management System](http://www.apache.org/dev/cms.html) to build the site.
 The whole process of buiding the site is automated with a Docker based build [script](./builder/bin/builder.sh).

 The required software you need is:

 *) [Git](https://git-scm.com/) - to checkout and commit
 *) [Docker](https://www.docker.com/) - builder.sh uses it to run Apache CMS that generates HTML out 
 of the Markdown files
 *) A text editor - to edit the [Markdown](https://www.markdownguide.org/) files
 *) A web browser - to review the changes in the generated HTML files

 Steps:

 1) Create a parent folder for the local Git clones

   export VELOCITY_PARENT_FOLDER="/path/to/velocity"
   mkdir -p $VELOCITY_PARENT_FOLDER
   cd $VELOCITY_PARENT_FOLDER
  
 2) Clone the GitHub repository for editing the Markdown files

   git clone --single-branch --branch main git@github.com:[YOUR_GITHUB_ID]/velocity-site.git

 4) Edit the Markdown files
  
   $VELOCITY_PARENT_FOLDER/velocity-site
   edit src/content/[FILE].mdtext

 5) Build the HTML files

   ./builder/bin/builder.sh

 6) Check the generated HTML locally

   open localhost:8000 in your favorite web browser 
   and navigate around to review your changes

 7) Commit your changes
 
   cd $VELOCITY_PARENT_FOLDER/velocity-site
   git commit -a -m "Some message explaining your changes"
   git push

 8) Create a Pull Request in GitHub UI


Questions and contact
---------------------

 If you have questions about the Apache Velocity Site building
 process, please ask the Velocity developers on the Velocity
 Developers mailing list at <dev@velocity.apache.org>.

