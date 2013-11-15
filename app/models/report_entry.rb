class ReportEntry < ActiveRecord::Base
  belongs_to :report
  belongs_to :order
end
