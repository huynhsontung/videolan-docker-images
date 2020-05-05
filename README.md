# VideoLAN docker images

VideoLAN docker images are used in [Jenkins] and [Gitlab CI] jobs to provide
static build environments.

On push, the Gitlab CI job will launch and figure out the images that need to
be rebuilt.

The results will be available on VideoLAN docker registry under
registry.videolan.org/$tag.

You can list the available tags for a given image by using get-docker-tags.sh image-name

If you require a new Linux distro to be a base of your future image(-s), please
put it under videolan-base-$distro directory.

The image builder uses a hacked version of Google's [kaniko] to be able to
build images in a non-compromised security-wise environment (e.g. not in
docker-in-docker privileged mode).


   [Jenkins]: <//jenkins.videolan.org>
   [Gitlab CI]: <http://code.videolan.org>
   [kaniko]: <https://github.com/GoogleContainerTools/kaniko>
