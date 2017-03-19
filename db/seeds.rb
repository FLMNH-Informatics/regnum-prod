# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Role.create([ 
    {:name => 'guest', :role_id => 1},
    {:name => 'user', :role_id => 2},
    {:name => 'reviewer_opt_out', :role_id => 3},
    {:name => 'reviewer_opt_in', :role_id => 4}, 
    {:name => 'reviewer', :role_id => 5},
    {:name => 'admin', :role_id => 6} 
])

Status.create([
    {:status => 'unsubmitted', :status_id => 1},
    {:status => 'submitted', :status_id => 2},
    {:status => 'returned', :status_id => 3},
    {:status => 'accepted', :status_id => 4},
    {:status => 'rejected', :status_id => 5}
])
