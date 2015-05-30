/*
   Author: Sam Gleske (https://github.com/samrocketman
   Configures the markup formatter in global security settings.
 */

import hudson.markup.RawHtmlMarkupFormatter

Jenkins.instance.setMarkupFormatter(new RawHtmlMarkupFormatter(false))

println 'Markup formatter configured.'
