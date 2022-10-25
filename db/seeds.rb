# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

clusters = Cluster.create([
                            {
                              name: "Test Cluster",
                              region: "us-east-1",
                              version: "1.25",
                              provider: "lbx"
                            }
                          ])