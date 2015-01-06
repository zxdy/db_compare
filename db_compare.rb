require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'
require 'pp'
require 'show_data'
require 'rbconfig'

$db_config = YAML::load(File.open('database.yml'))
$tables_config=YAML::load(File.open('tables.yml'))

class Prod_database < ActiveRecord::Base
  self.abstract_class = true
  establish_connection $db_config['PROD']
end

class Bts_database < ActiveRecord::Base
  self.abstract_class = true
  establish_connection $db_config['BTS']
end


class MetaProgramming
  def self.create_class(table_name,env)
    if env=='P'
      db_conn=Prod_database
    else
      db_conn=Bts_database
    end
    class_name = (env+table_name).capitalize
    dy_class = Object.const_set(class_name, Class.new(db_conn))
    dy_class.class_eval do
      self.table_name = table_name
    end
    dy_class
  end

end


def get_data_rpt(server_type,env,params)
  table_rpt={}
  $tables_config[server_type].split(' ').each do |table_name|
    begin
      table=MetaProgramming.create_class(table_name,env)
      data_count=table.where("pool=:pool and timestamp>= to_date(:start_date,'yyyymmdd') AND\
              timestamp <= to_date(:end_date,'yyyymmdd')+1",{pool:params[:pool],start_date:\
              params[:start_date], end_date: params[:end_date]}).count
      table_rpt[table_name]=data_count
    rescue Exception =>e
      table_rpt[table_name]=e
    end
  end
  puts env+":done!"
  return table_rpt
end


if __FILE__== $0
  ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
  params={
      :pool => 'tsj24',
      :start_date => '20141201',
      :end_date => '20141201'
  }
  start_time=Time.now
  puts start_time
  env_rpt={}
  env_rpt['BTS']=get_data_rpt("TAS",'B',params)
  env_rpt['PROD']=get_data_rpt("TAS",'P',params)
  puts format_data(env_rpt)
  end_time=Time.now
  puts end_time-start_time
end
