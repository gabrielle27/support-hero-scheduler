## seed the CA holidays

{
  "2015-09-07" => "Labor Day",
  "2015-09-25" => "Native American Day",
  "2015-11-11" => "Veterans' Day",
  "2015-11-26" => "Thanksgiving Day",
  "2015-11-27" => "Thanksgiving Friday",
  "2015-12-25" => "Christmas Day",
  "2016-01-01" => "New Year's Day",
  "2016-01-18" => "Martin Luther King Jr. Birthday",
  "2016-02-04" => "Rosa Parks Day",
  "2016-02-15" => "President's Day",
  "2016-03-31" => "César Chávez Day",
  "2016-05-30" => "Memorial Day",
  "2016-07-04" => "Independence Day",
  "2016-09-05" => "Labor Day",
  "2016-09-23" => "Native American Day",
  "2016-11-11" => "Veterans' Day",
  "2016-11-24" => "Thanksgiving Day",
  "2016-11-25" => "Thanksgiving Friday",
  "2016-12-25" => "Christmas Day",
  "2016-12-26" => "Christmas Day (Observed)"
}.each do |date, name|
  Holiday.create(support_date: date, name: name)
end
