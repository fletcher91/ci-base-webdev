# ci-base-webdev

A fully-featured CI runner image for web development.

Created out of the need as a GitLab CI default image, since setting up a different image for every project is cumbersome.

Out of the box:
- Docker
- Rbenv
- NVM
- Latest Ruby (2.3.1)
- Latest LTS Node.js (4.4.5)
- Libraries to build the most common gems & node packages


To use docker mount the image with `-v /var/run/docker.sock:/var/run/docker.sock` (see [this article](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/))
