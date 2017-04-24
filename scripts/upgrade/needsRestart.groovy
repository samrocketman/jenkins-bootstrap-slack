import hudson.model.UpdateCenter
import hudson.model.UpdateCenter.DownloadJob

UpdateCenter center = Jenkins.instance.updateCenter

println (center.jobs.findAll { it instanceof DownloadJob }.size() as Boolean).toString()
null
