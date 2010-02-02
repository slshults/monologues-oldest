# To change this template, choose Tools | Templates
# and open the template in the editor.

class ActiveRecordExtensions
  def conditions_by_like(value, *columns)
    columns = self.user_columns if columns.size == 0
    columns = columns[0] if columns[0].kind_of?(Array)
    conditions = columns.map {|c|
      c = c.name if c.kind_of? ActiveRecord::ConnectionAdapters::Column
      "'#{c}' LIKE " + ActiveRecord::Base.connection.quote("%#{value}%")
    }.join(" OR ")
  end
end
