require File.dirname(__FILE__) + '/../spec_helper'

describe "ActiveDirect::Router" do
  before(:each) do
    Category.delete_all
    Video.delete_all
  end

  it "should handle http raw post" do
    Category.count.should == 0
    params = {:action => 'Category', :method => 'create', :data => [{:name => 'category name'}], :type => 'rpc', :tid => 1 }
    do_post(params)
    Category.count.should == 1
  end
  it "should handle form post" do
    request = {
      "CONTENT_TYPE" => "application/x-www-form-urlencoded; charset=UTF-8"
    }
    response = post '/direct_router', "extTID=12&extAction=Video&extMethod=create_attachment&extType=rpc&extUpload=false&id=5&title=auau"  , request
    r = ActiveSupport::JSON.decode(response.body)
    r.should have_key "result"
    r["result"].should have_key "title"
    r["result"].should_not have_key "extUpload"
    r["result"].should_not have_key "extMethod"
    r["result"].should_not have_key "extType"
    r["result"].should_not have_key "extAction"
    r["result"].should_not have_key "extTID"
  end
  # TODO 
  it "should handle form post with file upload"
end
