# frozen_string_literal: true

require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::ControllerHelpers
  test 'can create a project' do
    sign_in User.create(email: Faker::Internet.email, password: Faker::Internet.password)
    post :create, project: { name: Faker::ProgrammingLanguage.name }
    project = assigns(:project)
    assert_not_nil project
  end
end
