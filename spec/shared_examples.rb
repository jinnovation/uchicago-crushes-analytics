shared_examples_for "table entry" do
  it { should_not be_blank }
  it { should_not be_nil }
end

shared_examples_for "positive integer" do
  it { should be > 0 }
end
