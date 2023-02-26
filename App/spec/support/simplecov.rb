require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage :branch
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec
end
