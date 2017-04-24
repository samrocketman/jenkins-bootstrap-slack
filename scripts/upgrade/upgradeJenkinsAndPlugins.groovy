import hudson.model.UpdateCenter

//Check for the latest update center updates from jenkins.io
Jenkins.instance.pluginManager.doCheckUpdatesServer()

//get the current update center
UpdateCenter center = Jenkins.instance.updateCenter

//upgrade Jenkins core
//fake emulate a stapler request
def req = [
	sendRedirect2: { String redirect -> null }
] as org.kohsuke.stapler.StaplerResponse
//detect if Jenkins core needs an upgrade
if(center.getCoreSource().data && center.getCoreSource().data.hasCoreUpdates() && !center.getHudsonJob()) {
    println "Upgrading Jenkins Core"
    center.doUpgrade(req)
}

//schedule an upgrade of all plugins
print "Upgrading Plugins: "
println center.updates.findAll { center.getJob(it) == null }.each { it.deploy(false) }*.name
null
