test_user_count = 10

users = [{
  :username         => "grauwoelfchen",
  :email            => "grauwoelfchen@gmail.com",
  :password         => "test",
  :activation_state => "active",
}, {
  :username         => "misakirschtorte",
  :email            => "misakirschtorte@gmail.com",
  :password         => "test",
  :activation_state => "pending"
}]

test_user_count.times do |i|
  users << {
    :username         => "test#{i}",
    :email            => "test#{i}@example.org",
    :password         => "test#{i}",
    :activation_state => %w[active pending].sample
  }
end

users.map do |u|
  user = User.create(u.merge(:password_confirmation => u[:password]))
  user.activate! if u[:activation_state] == "active"
end

nodes = {
  :grauwoelfchen => [{
    :name   => nil,
    :parent => nil
  }, {
    :name   => "Documents",
    :parent => :root
  }, {
    :name   => "Notes",
    :parent => "Documents"
  }, {
    :name   => "Wishlists",
    :parent => "Documents"
  }, {
    :name   => "Todos",
    :parent => :root
  }],
  :misakirschtorte => [{
    :name   => nil,
    :parent => nil
  }, {
    :name   => "Diary",
    :parent => :root
  }, {
    :name   => "Shopping-list",
    :parent => :root
  }, {
    :name   => "Recipe",
    :parent => :root
  }, {
    :name   => "Memo",
    :parent => :root
  }, {
    :name   => "Study",
    :parent => "Memo"
  }, {
    :name   => "Home",
    :parent => "Memo"
  }]
}

test_user_count.times do |i|
  nodes[:"test#{i}"] = [{
    :name   => nil,
    :parent => nil
  }, {
    :name   => "var",
    :parent => :root
  }]
end

nodes.map do |(username, tree)|
  user = User.find_by_username(username)
  tree.map do |n|
    if n[:name]
      attrs = {
        :name => n[:parent] == :root ? nil : n[:parent],
        :user => user
      }
      n[:parent] = Node.where(attrs).first
      node = user.nodes.new(n)
    end
    node = user.nodes.new(n)
    node.save(:validate => false)
  end
end
Node.rebuild!
