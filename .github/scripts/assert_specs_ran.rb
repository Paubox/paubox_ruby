#!/usr/bin/env ruby
# frozen_string_literal: true

# Fail CI when a green rspec exit code does not mean the suite ran.
#
# A passing run is not evidence of coverage: an error outside an example, a
# stray tag filter, or a spec_helper that stops loading files can leave rspec
# reporting success having executed almost nothing. The failure mode is
# invisible precisely because the exit code is 0.

require 'json'

# Floor, not a target. Only trips if coverage regresses; adding specs is free.
MIN_EXAMPLES = 250

summary = JSON.parse(File.read(ARGV.fetch(0))).fetch('summary')

total    = summary.fetch('example_count')
pending  = summary.fetch('pending_count')
failures = summary.fetch('failure_count')
errors   = summary.fetch('errors_outside_of_examples_count')
executed = total - pending

puts format(
  'examples=%d executed=%d failures=%d pending=%d errors_outside_examples=%d',
  total, executed, failures, pending, errors
)

problems = []
problems << "#{errors} error(s) outside of examples" if errors.positive?
if executed < MIN_EXAMPLES
  problems << "only #{executed} example(s) executed, expected at least #{MIN_EXAMPLES}"
end

unless problems.empty?
  warn "FAIL: #{problems.join('; ')}"
  exit 1
end

puts "OK: suite executed #{executed} examples"
