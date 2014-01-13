attributes :jid, :enqueued_at

node(:date) { |rollback_job|
  Date.parse(rollback_job.args.first)
}

node(:redownload) { |rollback_job|
  !!rollback_job.args.last
}
