class FitterHappierController < ActionController::Base
  session(:off) if Rails::VERSION::STRING < '2.3'
  layout nil
  
  def index
    render(:text => "FitterHappier Site Check Passed\n")
  end
  
  def site_check
    time = Time.now.to_formatted_s(:rfc822)
    render(:text => "FitterHappier Site Check Passed @ #{time}\n")
  end
  
  def site_and_database_check
    table_name = (Rails::VERSION::STRING >= '2.1.0' ? 'schema_migrations' : 'schema_info')
    query      = "SELECT version FROM #{table_name} ORDER BY version DESC LIMIT 1"
    version    = ActiveRecord::Base.connection.select_value(query)
    time       = Time.now.to_formatted_s(:rfc822)
    render(:text => "FitterHappier Site and Database Check Passed @ #{time}\nSchema Version: #{version}\n")
  end
  
  def git_hash
    render(:text => `git rev-parse HEAD`)
  end
  
  def uptime
    uptime = `uptime`
    pid1 = Process.pid # for script/server
    pid2 = `cat log/mongrel.pid` # for mongrel
    if pid2 == "" then
      pid = pid1
    else
      pid = pid2
    end
    render(:text => "Uptime: #{uptime} <br /> Process: <pre>" + `ps #{pid}` +"</pre>")
  end
  
  private
  
  def process_with_silence(*args)
    logger.silence do
      process_without_silence(*args)
    end
  end
 
  alias_method_chain :process, :silence
end