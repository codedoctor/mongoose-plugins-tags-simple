mongoose = require("mongoose")

_ = require 'underscore'

###
Provides a simple means to add tags to a schema.

options:
  noDuplicates - when set to true (default) it sorts the tags and removes all duplicates.
  lowercase - when set to true (default ) automatically converts all tags to lowercase.
  sort - when set to true (default) sorts the tags. Automatically set to true when noDuplicates is set to true.
###

exports.tagsSimple = (schema, options) ->
  options = {} unless options

  _.defaults options,
             noDuplicates : true
             lowercase : true
             sort : true
  options.sort = true if options.noDuplicates

  schema.add
    tags :
      type: [String]
      default: []


  schema.pre "save", (next) ->
    @tags = [] unless @tags
    @tags = _.map @tags, (x) -> x.toLowerCase() if options.lowercase
    @tags = @tags.sort() if options.sort && !options.noDuplicates # No Duplicates sorts against lowercase version
    @tags = _.uniq( @tags, false, (x) -> x.toLowerCase()) if options.noDuplicates

    next()
