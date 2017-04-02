# Upgrading

Download and add to your `$PATH` [`jenkins-call-url`][1].

Set up environment:

    source scripts/upgrade/env.sh

Bootstrap Jenkins so that it is running on `http://localhost:8080`.

Set up HTTP headers.

    unset JENKINS_CALL_ARGS
    jenkins-call-url -v -v http://localhost:8080 > /dev/null
    source scripts/upgrade/env.sh

# Upgrade Jenkins and plugins

Manually upgrade Jenkins and plugins from:

1. http://localhost:8080/manage - auto upgrade Jenkins.
2. http://localhost:8080/pluginManager/ - scroll to bottom, select all upgrades,
   download without restarting.
3. http://localhost:8080/restart - after upgrading both Jenkins and plugins
   restart Jenkins.

# Add missing plugins

> Note: from repository root

Look for missing plugins (see also [Jenkins Script Console][2]):

    jenkins-call-url ./scripts/upgrade/listShortName.groovy > /tmp/plugins

    while read x; do
      grep -- "$x" build.gradle > /dev/null || echo "Missing $x"
    done < /tmp/plugins

If there are missing plugins then add it to build.gradle in the `getplugins`
section referring to [`repo.jenkins-ci.org][3] for [GAV coordinates][4] of the
missing plugin.

# Upgrade build.gradle plugins

> Note: from repository root

Upgrade all of the plugins in the `build.gradle` file.

    jenkins-call-url scripts/upgrade/generateSedExpr.groovy > /tmp/plugins
    sed -i.bak -rf /tmp/plugins build.gradle

# Run through tests

After upgrading purge and bootstrap Jenkins again.  Run through the test
sequence documented in root README.

[1]: https://github.com/samrocketman/home/blob/master/bin/jenkins-call-url
[2]: https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+Script+Console
[3]: https://repo.jenkins-ci.org/
[4]: https://maven.apache.org/pom.html#Maven_Coordinates
