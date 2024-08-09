if Rails.env.development?
  puts 'Cleaning database...'
  UserRole.delete_all
  Role.delete_all
  User.delete_all
  Organization.delete_all

  puts 'Creating roles...'
  organization_role = Role.create!(name: Role::ORG_USER)
  individual_role = Role.create!(name: Role::INDIVIDUAL_USER)
  org_admin_role = Role.create!(name: Role::ORG_ADMIN)
  super_admin_role = Role.create!(name: Role::SUPER_ADMIN)

  puts 'Creating individual users...'
  individual_user = User.build(email: 'individual@example.com',
                              name: 'Individual User',
                              password: 'p@ssw0rd',
                              role_id: individual_role.id)
  individual_user.save!

  UserRole.create(user: individual_user, role: individual_role)


  puts 'Creating individual users as organization...'
  organization_user = User.build(email: 'organization@example.com',
                              name: 'User as Organization',
                              password: 'p@ssw0rd',
                              role_id: organization_role.id)
  organization_user.save!

  UserRole.create(user: organization_user, role: organization_role)

  puts 'Creating an organization...'
  organization = Organization.create(name: 'Dream', short_name: 'DR', email: 'dream@co.ltd')
  organization_user.update!(organization_id: organization.id)

  puts 'Creating a super admin...'
  super_admin_user = User.build(email: 'super_admin@example.com',
                                name: 'Super Admin',
                                password: 'p@ssw0rd',
                                role_id: super_admin_role.id)
  super_admin_user.save!
end
