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
                              provider: "lbx",
                              status: "available",
                              token: "eyJhbGciOiJSUzI1NiIsImtpZCI6ImMtVW1TWmJQUnk0dFd6WnRIc2hDOHZlZDVSNWc0UFkwWVFvTm5adThqZU0ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJsYngtc3lzdGVtIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImxhdW5jaGJveGhxLXRva2VuLWJ4ZGxiIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImxhdW5jaGJveGhxIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNDhhOGFmYWEtMTBmNS00MGM3LWFiMTctZTQ4ODE4NzVkMDBmIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmxieC1zeXN0ZW06bGF1bmNoYm94aHEifQ.r_YS9ZUKM4097l0Hsv1_0n3QMnH67hqWOFyltfLCfQ7fwONgZQfTj4Oljk7pEC2zkWSNB-hk5tqwCjDg1W6JRdigbi1AvC10S-uHvEEkogSvGs_Cpf8wHncwsLpQovlwqVtBKl_lyLEFa2XN4Lqgxes7d0owEeIy0cuzP322FJ5gm9NzkTvET1RkC5dQBzzee1k3_AOxB4F8TDESSnWvnzuYCFTFvJChBQN6vtHOMxIvBtB_xwDnOHHaD0rUE5k0GV-BaZ4bNb61j_dXY9uUpAfX6HsGE6d9lCyo7dxSYEXrePEfYAGMj96uKo9ZGhFAoQEiYSO8jT1vftKupYT5-g",
                              host: "https://192.168.1.12:6443",
                              ca_crt: "-----BEGIN CERTIFICATE-----
MIIBeDCCAR2gAwIBAgIBADAKBggqhkjOPQQDAjAjMSEwHwYDVQQDDBhrM3Mtc2Vy
dmVyLWNhQDE2NjY4MzYxNjEwHhcNMjIxMDI3MDIwMjQxWhcNMzIxMDI0MDIwMjQx
WjAjMSEwHwYDVQQDDBhrM3Mtc2VydmVyLWNhQDE2NjY4MzYxNjEwWTATBgcqhkjO
PQIBBggqhkjOPQMBBwNCAASqiAzbAZ/bjscXVhpjwVSUt3hlhmKCUShqT/uIHwBU
Iv5Cf86eOS25zGw0UlB1EoXJFTOT/UR5/xhWgX9l39BZo0IwQDAOBgNVHQ8BAf8E
BAMCAqQwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUlPTcWXtsQlK70ZRf30p0
KYKV3EgwCgYIKoZIzj0EAwIDSQAwRgIhAIKULBrGCbPsweRlGAc9WGL1iJ3iqaON
yiO2hXKYobu2AiEA+g1Xu4WnGwXqtoOBQaoX+rtNs0BnqDQh7Ar3DWoCb4I=
-----END CERTIFICATE-----",

                            }
                          ])