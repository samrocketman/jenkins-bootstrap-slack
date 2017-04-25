/*
   Reports true if any job within Jenkins is building.  Otherwise, returns false.
 */

import hudson.model.Job
import jenkins.model.Jenkins

println Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
    job.isBuilding()
} as Boolean
null
