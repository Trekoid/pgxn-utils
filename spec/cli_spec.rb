require File.expand_path('spec/spec_helper')

describe PgxnUtils::CLI do

  after(:all) do
    system "rm -rf /tmp/extension.*"
    system "rm -rf extension.*"
  end

  context "create skeleton" do
    before(:each) do
      @cli = PgxnUtils::CLI.new
    end

    it "should accepts or not a target" do
      expected_extension = next_extension

      File.should_not exist(expected_extension)
      skeleton "#{expected_extension}", "-p /tmp"
      File.should exist("/tmp/#{expected_extension}")

      File.should_not exist(expected_extension)
      skeleton "#{expected_extension}"
      File.should exist(expected_extension)
    end

    it "should store author's name, email, short_description, long_desctiption, tags" do
      expected_extension = next_extension
      expected_name = "Guedes"
      expected_mail = "guedes@none.here"
      expected_abstract = "Short description"
      expected_description = "Very Long description for my cool extension"
      expected_tags = "one two tree"

      skeleton expected_extension, "-p /tmp -m #{expected_name} -e #{expected_mail} -t #{expected_tags} -a '#{expected_abstract}' -d '#{expected_description}'"

      meta = File.read("/tmp/#{expected_extension}/META.json")
      meta.should match(/"name": "#{expected_extension}"/)
      meta.should match(/"abstract": "#{expected_abstract}"/)
      meta.should match(/"description": "#{expected_description}"/)
      meta.should match(/"#{expected_name} <#{expected_mail}>"/)
      meta.should match(/"file": "sql\/#{expected_extension}.sql"/)
      meta.should match(/"docfile": "doc\/#{expected_extension}.md"/)
      meta.should match(/"generated_by": "#{expected_name}"/)
      meta.should match(/"tags": \[ "one","two","tree" \],/)

      makefile = File.read("/tmp/#{expected_extension}/Makefile")
      makefile.should match(/EXTENSION    = #{expected_extension}/)

      control = File.read("/tmp/#{expected_extension}/#{expected_extension}.control")
      control.should match(/module_pathname = '\/#{expected_extension}'/)
    end

    it "should generates a skeleton" do
      extension = next_extension
      skeleton extension

      Dir["#{extension}/**/*"].sort.should == [
        "#{extension}/META.json",
        "#{extension}/Makefile",
        "#{extension}/README.md",
        "#{extension}/doc",
        "#{extension}/doc/#{extension}.md",
        "#{extension}/sql",
        "#{extension}/sql/#{extension}.sql",
        "#{extension}/sql/uninstall_#{extension}.sql",
        "#{extension}/test",
        "#{extension}/test/expected",
        "#{extension}/test/expected/base.out",
        "#{extension}/test/sql",
        "#{extension}/test/sql/base.sql",
        "#{extension}/#{extension}.control"
      ].sort
    end

    it "should generates a git repo"
  end

  context "bundle" do
    it "should bundle to zip by default"
    it "should create the name in semver spec"
  end

  context "release" do
    it "should send the bundle to PGXN"
  end

end
