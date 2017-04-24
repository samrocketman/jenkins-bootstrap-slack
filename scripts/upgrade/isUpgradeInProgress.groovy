import hudson.model.UpdateCenter
import hudson.model.UpdateCenter.DownloadJob
import hudson.model.UpdateCenter.DownloadJob.Success

UpdateCenter center = Jenkins.instance.updateCenter

println (center.jobs.findAll { it instanceof DownloadJob }.findAll { !(it.status instanceof Success) }.size() as Boolean).toString()
null
