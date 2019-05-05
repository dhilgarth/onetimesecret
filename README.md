# DOCKERIZED ONE-TIME SECRET
*Keep sensitive info out of your email & chat logs.*

## What's in it?
Based on ['civisanalytics/onetimesecret'](https://github.com/civisanalytics/onetimesecret/commit/07620fcb0a2acd95b74f3d87d2efafd2308da67b) which in turn is based on [the original OTS](https://github.com/civisanalytics/onetimesecret/commit/d34aec9cad8212273dec5041fe588646524abaf8).

Changes by CivisAnalytics:

Dockerized One-Time Secret (DOTS) is based off of One-Time Secret (OTS) version 0.10.0. We saw the need to upgrade Ruby from 1.9.3, and several outdated gems with vulnerabilies (as identified by Gemnasium), and in the process of making these upgrades and deploying the application internally, elected to use Docker and Docker compose.  The following changes were made over v0.10.0:

    * upgraded Ruby from 1.9.3 to 2.4.1
    * upgraded the following insecure gems
        * rack
        * mail
        * httparty
    * upgraded Redis from 2.6 to 3.2

Changes by Sovarto:

* Fixed build errors due to Debian Jessie updates having been removed from the debian repositories
* Fixed warnings during build when creating the user
* Fixed storing of the secret. It was changed on each container start.
* Now allows the configuration of the external redis host through the environment variable `REDIS_HOST`
* Cleaned up the user interface by hiding account creation, login, social media links etc. Can easily be re-enabled if necessary, check the changes in commits 0e8d688f2 and b558c8668.

See the contained `docker-compose.yml` for a full sample.

## Usage
See `docker-compose.yml`