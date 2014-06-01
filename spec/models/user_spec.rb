require 'spec_helper'

describe User do
  it { should respond_to :name }
  it { should respond_to :pic_url }
  it { should respond_to :profile_url }
end
