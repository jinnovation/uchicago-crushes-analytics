require 'spec_helper'

describe Crush do
  it { should respond_to :content }
  it { should respond_to :user_id }
  it { should respond_to :post_url }

end
