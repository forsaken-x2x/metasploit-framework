module HostDataProxy

  def hosts(wspace = workspace, non_dead = false, addresses = nil)
    begin
      data_service = self.get_data_service()
      opts = {}
      opts[:wspace] = wspace
      opts[:non_dead] = non_dead
      opts[:addresses] = addresses
      data_service.hosts(opts)
    rescue Exception => e
      elog "Problem retrieving hosts: #{e.message}"
    end
  end

  # TODO: Shouldn't this proxy to RemoteHostDataService#find_or_create_host ?
  # It's currently skipping the "find" part
  def find_or_create_host(opts)
    report_host(opts)
  end

  def report_host(opts)
    return unless valid(opts)

    begin
      data_service = self.get_data_service()
      data_service.report_host(opts)
    rescue Exception => e
      elog "Problem reporting host: #{e.message}"
    end
  end

  def report_hosts(hosts)
    begin
      data_service = self.get_data_service()
      data_service.report_hosts(hosts)
    rescue Exception => e
      elog "Problem reporting hosts: #{e.message}"
    end
  end

  def delete_host(opts)
    begin
      data_service = self.get_data_service()
      data_service.delete_host(opts)
    rescue Exception => e
      elog "Problem removing host: #{e.message}"
    end
  end

  private

  def valid(opts)
    unless opts[:host]
      ilog 'Invalid host hash passed, :host is missing'
      return false
    end

    # Sometimes a host setup through a pivot will see the address as "Remote Pipe"
    if opts[:host].eql? "Remote Pipe"
      ilog "Invalid host hash passed, address was of type 'Remote Pipe'"
      return false
    end

    return true
  end

end
