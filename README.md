# VideoLAN docker images

VideoLAN docker images are used in [Jenkins] jobs to provide static build environments.

On push, the [Docker Images Job] will launch and figure out the images that need to be rebuilt.

The results will be available on VideoLAN docker registry under registry.videolan.org:5000/$tag.

If you require a new Linux distro to be a base of your future image(-s), please put it under videolan-base-$distro directory.


To add a new build on Jenkins:

 * Log in to Jenkins and go under [Configure Jenkins].
 * At the bottom of the page, click "Add Docker Template".
 * Fill in the following fields:
   1. Docker Image: registry.videolan.org:5000/$tag
   2. Labels: $tag
   3. Credentials: "jenkins/****** (jenkins for docker containers)"
   4. Instance capacity: leave blank.
 * Click Save.
 * Create a new freestyle job Item under an appropriate Folder.


   [Jenkins]: <//jenkins.videolan.org>
   [Docker Images Job]: <https://jenkins.videolan.org/job/Infrastructure/job/Docker%20images/>
   [Configure Jenkins]: <//jenkins.videolan.org/configure>
